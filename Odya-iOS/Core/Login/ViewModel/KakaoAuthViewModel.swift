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
    
    /// 로그인 상태
    var isKakaoLoggedIn: Bool = false
    @Published var isLoggedIn: Bool = false
    
    /// 토큰
    private var kakaoAccessToken: String?
    @AppStorage("WeITAuthToken") var idToken: String?
    
    /// 자동로그인 확인을 위한 토큰
//    @AppStorage("accessToken") var kakaoAccessToken: String?
//    @AppStorage("accessToken") var hasValidKakaoAccessToken: Bool = false
    
    /// 사용자 정보
    @Published var userInfo: UserInfo? = nil
    
    @Published var AuthApi = AuthViewModel()
    
    
    @MainActor
    func kakaoLogin() {
        idToken = nil
        Task {
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 실행 가능할 경우, 카카오톡 앱을 이용해 로그인
                await isKakaoLoggedIn = handleKakaoLoginWithKakaoTalk()
            } else {
                // 카카오톡 실행 불가능할 경우, 웹 뷰를 이용해 로그인
                await isKakaoLoggedIn = handleKakaoLoginWithAccount()
            }
            if isKakaoLoggedIn == true {
                // print("kakao social login success")
                if let token = kakaoAccessToken {
                    doServerLogin(token: token)
                } else{
                    print("Error in KakaoAuthViewModel kakaoLogin(): kakao social login failed")
                }
            }
        }
    }
    
    func doServerLogin(token: String) {
        AuthApi.kakaoLogin(accessToken: token) { result in
            switch result {
            case .success(let firebaseToken):
                Auth.auth().signIn(withCustomToken: firebaseToken) { (firebaseSignInResult, error) in
                    if let error = error {
                        print("Error in KakaoAuthViewModel kakaoLogin() - Firebase custom token authentication failed: \(error.localizedDescription)")
                        return
                    }
                    
                    // print("Firebase custom token authentication successful!")
                    
                    // idToken 유효성 확인
                    let currentUser = Auth.auth().currentUser
                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        if let error = error {
                            print("Error in KakaoAuthViewModel kakaoLogin(): \(error.localizedDescription)")
                            return
                        }
                        
                        // idToken을 이용해 서버 로그인
                        if let idToken = idToken {
                            self.idToken = idToken
                            return
                        } else {
                            print("Error in KakaoAuthViewModel kakaoLogin(): Invalid Token")
                            return
                        }
                    }
                }
            case .unauthorized(let data):
                if let newUserData = data {
                    // print("sign up view, username: \(newUserData.username), nickname: \(newUserData.nickname), email: \(newUserData.email ?? ""), gender: \(newUserData.gender ?? "")")
                }
                // TODO:  SignUpView 연결
            case .error(let errorMessage):
                print("Error in KakaoAuthViewModel kakaoLogin() - kakao server login faild: \(errorMessage)")
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
                isLoggedIn = false
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
    
    // MARK: FUNCTIONS-USER INFO
    
    /// 카카오 계정 사용자 정보 userInfo로 가져오기
//    func getUserInfoFromKakao(username: String, nickname: String)  {
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print("Error: \(error)")
//            }
//            else {
//                // print("me() success.")
//
//                //do something
//                self.userInfo = user
//            }
//        }
//    }

    
    /*// 아직 기능 체크 안함
    func updateUserInfo() {
        UserApi.shared.updateProfile(properties: ["${CUSTOM_PROPERTY_KEY}":"${CUSTOM_PROPERTY_VALUE}"]) {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("updateProfile() success.")
            }
        }
    } */
    

}
