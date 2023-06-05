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


class KakaoAuthViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    /// 로그인 상태
    @Published var isLoggedIn: Bool = false
    
    /// 자동로그인 확인을 위한 토큰
    @AppStorage("accessToken") var kakaoAccessToken: String?
    
    /// 사용자 정보
    @Published var userInfo: User? = nil
    
    
    // MARK: FUNCTIONS-LOGIN
    
    @MainActor
    func kakaoLogin() {
        Task {
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 실행 가능할 경우, 카카오톡 앱을 이용해 로그인
                await isLoggedIn = handleKakaoLoginWithKakaoTalk()
            } else {
                // 카카오톡 실행 불가능할 경우, 웹 뷰를 이용해 로그인
                await isLoggedIn = handleKakaoLoginWithAccount()
            }
            if isLoggedIn == true {
                print("kakao login success")
                getUserInfoFromKakao()
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
                    
                    //do something
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
                    
                    //do something
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
                kakaoAccessToken = nil
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
    func getUserInfoFromKakao()  {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print("Error: \(error)")
            }
            else {
                // print("me() success.")

                //do something
                self.userInfo = user
            }
        }
    }

    
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
