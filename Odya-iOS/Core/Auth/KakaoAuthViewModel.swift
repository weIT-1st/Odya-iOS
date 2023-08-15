//
//  KakaoAuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import SwiftUI
import Combine
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

class KakaoAuthViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    @Published var AuthApi = AuthViewModel()
    
    /// 로그인 상태
    var isKakaoLoggedIn: Bool = false
    @Published var isLoginFailed: Bool = false
    @Published var isUnauthorized: Bool = false
    
    /// 토큰
    var kakaoAccessToken: String?
    @AppStorage("WeITAuthToken") var idToken: String?
    
    /// 사용자 정보
    @Published var userInfo = UserInfo()
    
    // MARK: FUNCTIONS
    
    @MainActor
    func kakaoLogin() {
        idToken = nil
        Task {
            // 카카오 소셜 로그인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                await isKakaoLoggedIn = handleKakaoLoginWithKakaoTalk()
            } else {
                await isKakaoLoggedIn = handleKakaoLoginWithAccount()
            }
            
            // 카카오 소셜 로그인 실패
            guard isKakaoLoggedIn == true,
                  let token = kakaoAccessToken else {
                print("Error in KakaoAuthViewModel kakaoLogin(): kakao social login failed")
                isLoginFailed = true
                // TODO: 필요하다면 alert
                // TODO: 다시 로그인뷰로
                return
            }
            
            // 서버로그인
            doServerLogin(token: token)
        }
    }
    
    func doServerLogin(token: String) {
        AuthApi.kakaoLogin(accessToken: token) { result in
            switch result {
            case .success(let firebaseToken):
                self.doFirebaseLogin(firebaseToken)
            case .unauthorized(let data):
                if let newUserData = data?.data {
                    // 카카오에서 얻은 유저정보 저장
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
                // 회원가입 뷰로 연결
                self.isUnauthorized = true
            case .error(let errorMessage):
                print("Error in KakaoAuthViewModel kakaoLogin() - kakao server login faild: \(errorMessage)")
                self.isLoginFailed = true
                // TODO: 아마... 로그인 뷰로..? 다시 소셜로그인부터..?
            }
        }
    }
    
    func doFirebaseLogin(_ firebaseToken: String) {
        Auth.auth().signIn(withCustomToken: firebaseToken) { (firebaseSignInResult, error) in
            if let error = error {
                print("Error in KakaoAuthViewModel kakaoLogin() - Firebase custom token authentication failed: \(error.localizedDescription)")
                self.isLoginFailed = true
                return
                // TODO: 에러처리 어떻게..? 다시 로그인뷰로..??
            }
            
            // idToken 유효성 확인
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error in KakaoAuthViewModel kakaoLogin(): \(error.localizedDescription)")
                    self.isLoginFailed = true
                    return
                }
                guard let idToken = idToken else {
                    print("Error in KakaoAuthViewModel kakaoLogin(): Invalid Token")
                    self.isLoginFailed = true
                    return
                }
                
                // idToken을 이용해 서버 로그인
                self.idToken = idToken
                return
            }
        }
    }
    
    /// 카카오톡 앱을 이용해 로그인 처리
    func handleKakaoLoginWithKakaoTalk() async -> Bool {
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("Error: \(error)")
                    continuation.resume(returning: false)
                }
                else {
                    // print("loginWithKakaoTalk() success.")
                    self.kakaoAccessToken = oauthToken?.accessToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    /// 카카오 웹 뷰를 이용해 로그인 처리
    func handleKakaoLoginWithAccount() async -> Bool {
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print("Error: \(error)")
                    continuation.resume(returning: false)
                }
                else {
                    // print("loginWithKakaoAccount() success.")
                    self.kakaoAccessToken = oauthToken?.accessToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    
    // MARK: FUNCTIONS-LOGOUT
    
    /// 카카오 계정 로그아웃
    @MainActor
    func kakaoLogout() {
        Task {
            if await handlekakaoLogout() {
                idToken = nil
                print("kakao logout seccess")
            }
        }
    }
    
    /// 카카오 로그아웃 처리
    func handlekakaoLogout() async -> Bool {
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print("Error \(error)")
                    continuation.resume(returning: false)
                }
                else {
                    // print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }

}
