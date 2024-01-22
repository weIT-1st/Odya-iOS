//
//  SignUpViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/27.
//

import Combine
import Moya
import SwiftUI

class SignUpViewModel: ObservableObject {
  // MARK: Properties
  
  /// combine
  var subscription = Set<AnyCancellable>()
  
  /// idToken
  @AppStorage("WeITAuthToken") var idToken: String?
  
  /// 회원가입 시도한 소셜 로그인 타입
  @AppStorage("WeITAuthType") var authType: String = ""
  
  /// 계정 상태, 회원가입 성공 시 unauthorized -> additionalSetUpRequired
  @AppStorage("WeITAuthState") var authState: AuthState = .unauthorized
  
  /// 카카오 회원가입 시 사용자 등록 후 파이어베이스 로그인을 통해 idToken 발급받기 위함
  let kakaoAccessToken: String
  
  /// 회원가입 단계
  @Published var step: Int = -1
  
  /// 회원가입 데이터
  @Published var userInfo: SignUpInfo
  @Published var favoriteTopicIds: [Int] = []
  
  // MARK: Init
  init(userInfo: SignUpInfo,
       kakaoAccessToken: String = "") {
    self.userInfo = userInfo
    self.kakaoAccessToken = kakaoAccessToken
  }
  
  // MARK: Sign Up
  func signUp(completion: @escaping (Bool) -> Void) {
    switch authType {
    case "kakao":
      kakaoRegister(username: userInfo.username,
                    email: userInfo.email,
                    phoneNumber: userInfo.phoneNumber,
                    nickname: userInfo.nickname,
                    gender: userInfo.gender.toServerForm(),
                    birthday: userInfo.birthday.toIntArray(),
                    termsIdList: userInfo.termsIdList) { (success, errMsg) in
        if success {
          print("카카오로 회원가입 성공")
          // 사용자 정보 초기화
          AppDataManager().initMyData() { success in
            completion(success)
          }
        } else {
          print("카카오로 회원가입 실패 - \(errMsg ?? "")")
        }
      }
    case "apple":
      appleRegister(idToken: userInfo.idToken,
                    email: userInfo.email,
                    phoneNumber: userInfo.phoneNumber,
                    nickname: userInfo.nickname,
                    gender: userInfo.gender.toServerForm(),
                    birthday: userInfo.birthday.toIntArray(),
                    termsIdList: userInfo.termsIdList) { (success, errMsg) in
        if success {
          print("애플로 회원가입 성공")
          self.idToken = self.userInfo.idToken
          // 사용자 정보 초기화
          AppDataManager().initMyData() { success in
            completion(success)
          }
        } else {
          print("애플로 회원가입 실패 - \(errMsg ?? "")")
        }
      }
    default:
      authState = .loggedOut
      return
    }
  }
  
  // MARK: -- Kakao Register
  private func kakaoRegister( username: String,
                              email: String?,
                              phoneNumber: String?,
                              nickname: String,
                              gender: String,
                              birthday: [Int],
                              termsIdList: [Int],
                              completion: @escaping (Bool, String?) -> Void) {
    AuthApiService.kakaoRegister(
      username: username, email: email, phoneNumber: phoneNumber, nickname: nickname,
      gender: gender, birthday: birthday, termsIdList: termsIdList
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        // 카카오 로그인, 파이어베이스 idToken을 발급받음
        if self.kakaoAccessToken != "" {
          KakaoAuthViewModel().doServerLogin(token: self.kakaoAccessToken) { (success, token) in
            if success {
              self.idToken = token
              completion(true, "")
              return
            }
          }
        } else {
          completion(false, "카카오 토큰 오류")
        }
        
      case .failure(let error):
        switch error {
        case .http(let errorData):
          completion(false, errorData.message)
        default:
          completion(false, error.localizedDescription)
        }
      }
    } receiveValue: { _ in }
    .store(in: &subscription)
  }
  
  // MARK: -- Apple Register
  private func appleRegister(idToken: String,
                             email: String?,
                             phoneNumber: String?,
                             nickname: String,
                             gender: String,
                             birthday: [Int],
                             termsIdList: [Int],
                             completion: @escaping (Bool, String?) -> Void) {
    AuthApiService.appleRegister(
      idToken: idToken, email: email, nickname: nickname, phoneNumber: phoneNumber, gender: gender,
      birthday: birthday, termsIdList: termsIdList
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        completion(true, nil)
      case .failure(let error):
        switch error {
        case .http(let errorData):
          completion(false, errorData.message)
        default:
          completion(false, error.localizedDescription)
        }
      }
    } receiveValue: { _ in }
    .store(in: &subscription)
  }
}
