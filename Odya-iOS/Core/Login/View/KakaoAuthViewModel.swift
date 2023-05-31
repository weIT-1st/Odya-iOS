//
//  KakaoAuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import SwiftUI
import Combine
import KakaoSDKUser

class KakaoAuthViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    /// 로그인 상태
    @Published var isLoggedIn: Bool = false
    
    
    // MARK: FUNCTIONS-LOGIN
    
    /// 카카오 로그인
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
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    
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
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    
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
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }

}
