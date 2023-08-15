//
//  KakaoAuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import Combine
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import SwiftUI

class KakaoAuthViewModel: ObservableObject {

  // MARK: Properties

  @Published var AuthApi = AuthViewModel()

  /// 로그인 상태
  var isKakaoLoggedIn: Bool = false
  @Published var isLoginFailed: Bool = false
  @Published var isUnauthorized: Bool = false

  /// 토큰
  var kakaoAccessToken: String?
  @AppStorage("WeITAuthToken") var idToken: String?
  @AppStorage("WeITAuthType") var authType: String = ""

  /// 로그인한 회원 정보 - 회원가입 시 사용됨
  @Published var userInfo = UserInfo()

  // MARK: Sign In With Kakao Handling

  @MainActor
  /// 카카오 소셜 로그인 -> 서버 로그인 -> 서버 로그인 성공 시 받아온 토큰으로 파이어베이스 로그인/연동
  func kakaoLogin() {
    idToken = nil
    Task {
      // kakao social login
      if UserApi.isKakaoTalkLoginAvailable() {
        await isKakaoLoggedIn = handleKakaoLoginWithKakaoTalk()
      } else {
        await isKakaoLoggedIn = handleKakaoLoginWithAccount()
      }

      // kakao social login failed
      guard isKakaoLoggedIn == true,
        let token = kakaoAccessToken
      else {
        print("Error: Kakao social login failed")
        isLoginFailed = true
        // TODO: 필요하다면 alert
        // TODO: 다시 로그인뷰로
        return
      }

      // server login & firebase login
      doServerLogin(token: token)
    }
  }

  /// 카카오톡 앱을 이용해 로그인 처리
  func handleKakaoLoginWithKakaoTalk() async -> Bool {
    await withCheckedContinuation { continuation in
      UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
        if let error = error {
          print("Error: \(error)")
          continuation.resume(returning: false)
        } else {
          // print("loginWithKakaoTalk() success.")
          self.kakaoAccessToken = oauthToken?.accessToken
          continuation.resume(returning: true)
        }
      }
    }
  }

  /// 카카오 웹 뷰를 이용해 로그인 처리
  func handleKakaoLoginWithAccount() async -> Bool {
    await withCheckedContinuation { continuation in
      UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
        if let error = error {
          print("Error: \(error)")
          continuation.resume(returning: false)
        } else {
          // print("loginWithKakaoAccount() success.")
          self.kakaoAccessToken = oauthToken?.accessToken
          continuation.resume(returning: true)
        }
      }
    }
  }

  // MARK: Server Login

  /// 서버 로그인 api 호출
  /// 서버 로그인 성공 시 받아온 토큰으로 파이어베이스 로그인/연동
  /// 등록되지 않은 회원일 경우 회원가입 페이지로 이동
  func doServerLogin(token: String) {
    AuthApi.kakaoLogin(accessToken: token) { result in
      switch result {
      case .success(let firebaseToken):
        self.doFirebaseLogin(firebaseToken)
      case .unauthorized(let data):
        // 카카오에서 얻은 유저정보 저장
        if let newUserData = data?.data {
          self.userInfo.username = newUserData.username
          self.userInfo.nickname = newUserData.nickname
          if let email = newUserData.email {
            self.userInfo.email = email
          }
          if let phoneNumber = newUserData.phoneNumber {
            self.userInfo.phoneNumber = phoneNumber
          }
          if let gender = newUserData.gender {
            self.userInfo.gender = gender == "M" ? .male : .female
          }
        }
        // 회원가입 페이지로 연결
        self.isUnauthorized = true
      case .error(let errorMessage):
        print("Error: kakao server login faild: \(errorMessage)")
        self.isLoginFailed = true
      // TODO: 아마... 로그인 뷰로..? 다시 소셜로그인부터..?
      }
    }
  }

  // MARK: Firebase Login

  /// 파이어베이스 로그인
  /// 성공 시 토큰 저장
  func doFirebaseLogin(_ firebaseToken: String) {
    Auth.auth().signIn(withCustomToken: firebaseToken) { (firebaseSignInResult, error) in
      if let error = error {
        print("Error: Firebase custom token authentication failed: \(error.localizedDescription)")
        self.isLoginFailed = true
        return
        // TODO: 에러처리 어떻게..? 다시 로그인뷰로..??
      }

      // idToken 유효성 확인
      let currentUser = Auth.auth().currentUser
      currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        if let error = error {
          print("Error: \(error.localizedDescription)")
          self.isLoginFailed = true
          return
        }
        guard let idToken = idToken else {
          print("Error: Invalid Token")
          self.isLoginFailed = true
          return
        }

        // idToken을 이용해 서버 로그인
        self.idToken = idToken
        self.authType = "kakao"
        return
      }
    }
  }

  // MARK: Logout

  /// 카카오 계정 로그아웃
  @MainActor
  func kakaoLogout() {
    Task {
      if await handlekakaoLogout() {
        idToken = nil
        authType = ""
        // print("kakao logout seccess")
      }
    }
  }

  /// 카카오 로그아웃 처리
  func handlekakaoLogout() async -> Bool {
    await withCheckedContinuation { continuation in
      UserApi.shared.logout { error in
        if let error = error {
          print("Error \(error)")
          continuation.resume(returning: false)
        } else {
          continuation.resume(returning: true)
        }
      }
    }
  }
}
