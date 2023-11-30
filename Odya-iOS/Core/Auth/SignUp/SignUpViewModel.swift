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
  /// combine
  var subscription = Set<AnyCancellable>()
  
  /// 로그인 타입
  let socialType: SocialLoginType
  
  /// 회원가입 단계
  @Published var step: Int = -1
  
  /// 회원가입 데이터
  @Published var userInfo: SignUpInfo
  
  init(socialType: SocialLoginType, userInfo: SignUpInfo) {
    self.socialType = socialType
    self.userInfo = userInfo
  }
  
  func signUp() {
    print("sign up")
    
    switch socialType {
    case .kakao:
      kakaoRegister(username: userInfo.username,
                    email: userInfo.email,
                    phoneNumber: userInfo.phoneNumber,
                    nickname: userInfo.nickname,
                    gender: userInfo.gender.toServerForm(),
                    birthday: userInfo.birthday.toIntArray(),
                    termsIdList: userInfo.termsIdList) { (success, errMsg) in
        if success {
          print("카카오로 회원가입 성공")
          self.step += 1
        } else {
          print("카카오로 회원가입 실패 - \(errMsg ?? "")")
        }
      }
    case .apple:
      appleRegister(idToken: userInfo.idToken,
                    email: userInfo.email,
                    phoneNumber: userInfo.phoneNumber,
                    nickname: userInfo.nickname,
                    gender: userInfo.gender.toServerForm(),
                    birthday: userInfo.birthday.toIntArray(),
                    termsIdList: userInfo.termsIdList) { (success, errMsg) in
        if success {
          print("애플로 회원가입 성공")
          self.step += 1
        } else {
          print("애플로 회원가입 실패 - \(errMsg ?? "")")
        }
      }
    case .unknown:
      // 테스트용
      self.step += 1
      return
    }
  }
  
  private func kakaoRegister( username: String,
                              email: String?,
                              phoneNumber: String?,
                              nickname: String,
                              gender: String,
                              birthday: [Int],
                              termsIdList: [Int],
                              completion: @escaping (Bool, String?) -> Void) {
    // print("AuthVM - kakaoRegister() called")
    var isSuccess = false
    var errorMessage: String? = nil

    AuthApiService.kakaoRegister(
      username: username, email: email, phoneNumber: phoneNumber, nickname: nickname,
      gender: gender, birthday: birthday, termsIdList: termsIdList
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
//        print("회원가입(카카오) 완료")
        isSuccess = true
        errorMessage = nil
      case .failure(let error):
        isSuccess = false
        switch error {
        case .http(let errorData):
//          print("Error: \(errorData.message)")
          errorMessage = errorData.message
        default:
//          debugPrint("Error: \(error)")
          errorMessage = error.localizedDescription
        }
      }
      completion(isSuccess, errorMessage)
    } receiveValue: { response in
      debugPrint(response)
    }.store(in: &subscription)
  }
  
  private func appleRegister(idToken: String,
                             email: String?,
                             phoneNumber: String?,
                             nickname: String,
                             gender: String,
                             birthday: [Int],
                             termsIdList: [Int],
                             completion: @escaping (Bool, String?) -> Void) {
    // print("AuthVM - appleRegister() called")
    var isSuccess = false
    var errorMessage: String? = nil

    AuthApiService.appleRegister(
      idToken: idToken, email: email, nickname: nickname, phoneNumber: phoneNumber, gender: gender,
      birthday: birthday, termsIdList: termsIdList
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        // print("회원가입(애플) 완료")
        isSuccess = true
        errorMessage = nil
      case .failure(let error):
        isSuccess = false
        switch error {
        case .http(let errorData):
          // print("Error: \(errorData.message)")
          errorMessage = errorData.message
        default:
          // debugPrint("Error: \(error)")
          errorMessage = error.localizedDescription
        }
      }
      completion(isSuccess, errorMessage)
    } receiveValue: { response in
      debugPrint(response)
    }.store(in: &subscription)
  }
}
