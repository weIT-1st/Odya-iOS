//
//  AuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Alamofire
import Combine
import Foundation

enum LoginResponseResult {
  case success(String)
  case unauthorized(KakaoLoginErrorResponse?)
  case error(String)
}

class AuthViewModel: ObservableObject {
  var subscription = Set<AnyCancellable>()

  @Published var loggedInUser: UserInfo? = nil

  /// 카카오 회원가입
  func kakaoRegister(
    username: String,
    email: String?,
    phoneNumber: String?,
    nickname: String,
    gender: String,
    birthday: [Int],
    completion: @escaping (Bool, String?) -> Void
  ) {
    print("AuthVM - kakaoRegister() called")
    var isSuccess = false
    var errorMessage: String? = nil

    AuthApiService.kakaoRegister(
      username: username, email: email, phoneNumber: phoneNumber, nickname: nickname,
      gender: gender, birthday: birthday
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        print("회원가입(카카오) 완료")
        isSuccess = true
        errorMessage = nil
      case .failure(let error):
        isSuccess = false
        switch error {
        case .http(let errorData):
          print("Error: \(errorData.message)")
          errorMessage = errorData.message
        default:
          debugPrint("Error: \(error)")
          errorMessage = error.localizedDescription
        }
      }
      completion(isSuccess, errorMessage)
    } receiveValue: { response in
      debugPrint(response)
    }.store(in: &subscription)
  }

  /// 애플 회원가입
  func appleRegister(
    idToken: String,
    email: String?,
    phoneNumber: String?,
    nickname: String,
    gender: String,
    birthday: [Int],
    completion: @escaping (Bool, String?) -> Void
  ) {
    print("AuthVM - appleRegister() called")
    var isSuccess = false
    var errorMessage: String? = nil

    AuthApiService.appleRegister(
      idToken: idToken, email: email, nickname: nickname, phoneNumber: phoneNumber, gender: gender,
      birthday: birthday
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        print("회원가입(애플) 완료")
        isSuccess = true
        errorMessage = nil
      case .failure(let error):
        isSuccess = false
        switch error {
        case .http(let errorData):
          print("Error: \(errorData.message)")
          errorMessage = errorData.message
        default:
          debugPrint("Error: \(error)")
          errorMessage = error.localizedDescription
        }
      }
      completion(isSuccess, errorMessage)
    } receiveValue: { response in
      debugPrint(response)
    }.store(in: &subscription)
  }

  /// 카카오 로그인
  func kakaoLogin(
    accessToken: String,
    completion: @escaping (LoginResponseResult) -> Void
  ) {
    print("AuthVM - kakaoLogin() called")
    var receivedToken: String = ""

    AuthApiService.kakaoLogin(accessToken: accessToken)
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          print("카카오 로그인 완료")
          completion(.success(receivedToken))
        case .failure(let error):
          print("카카오 로그인 실패")
          switch error {
          case .http(let errorData):
            // print(errorData.message)
            completion(.error(errorData.message))
          case .unauthorizedToken(let newUserData):
            // print("Error: need to register \(newUserData.username)")
            completion(.unauthorized(newUserData))
          default:
            // debugPrint("Error: \(error)")
            completion(.error(error.localizedDescription))
          }
        }
      } receiveValue: { response in
        debugPrint(response)
        receivedToken = response.token
      }.store(in: &subscription)
  }

  /// 애플 로그인
  func appleLogin(
    idToken: String,
    completion: @escaping (LoginResponseResult) -> Void
  ) {
    print("AuthVM - AppleLogin() called")

    AuthApiService.appleLogin(idToken: idToken)
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          print("애플 로그인 완료")
          completion(.success(""))
        case .failure(let error):
          print("애플 로그인 실패")
          switch error {
          case .http(let errorData):
            print(errorData.message)
            if errorData.code == -10005 {
              completion(.unauthorized(nil))
            } else {
              completion(.error(errorData.message))
            }
          default:
            debugPrint("Error: \(error)")
            completion(.error(error.localizedDescription))
          }
        }
      } receiveValue: { response in
        debugPrint(response)
      }.store(in: &subscription)
  }
}
