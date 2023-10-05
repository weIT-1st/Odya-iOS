//
//  Odya_iOSApp.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI
import KakaoSDKUser


@main
struct Odya_iOSApp: App {
    
    // MARK: PROPERTIES
    
    // with AppDelegate.swift
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    @StateObject private var appleAuthVM = AppleAuthViewModel()
    @StateObject private var kakaoAuthVM = KakaoAuthViewModel()
    
    /// 카카오 자동로그인 확인을 위한 토큰
    @AppStorage("WeITAuthToken") var idToken: String?
    @AppStorage("WeITAuthType") var authType: String = ""
    
    /// 애플 자동로그인 확인을 위한 인증 유효 여부
//    @AppStorage("isAppleSignInValid") var isAppleSignInValid: Bool = AppleUserData.isValid

    // MARK: BODY
    var body: some Scene {
        WindowGroup {
            FeedView()
            if let token = idToken {
                RootTabView(token: token)
            } else {
                LoginView()
                    .environmentObject(appleAuthVM)
                    .environmentObject(kakaoAuthVM)
            }
        }
    }
    
    /*/ without AppDelegate.swift
    init() {
        let kakaoApiKey = Bundle.main.infoDictionary?["d8b402ca46c000a2f1bff61ed7a80243"] ?? ""
        print("kakaoApiKey: \(kakaoApiKey)")
        
        // kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoApiKey)
    }

    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            ContentView().onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    } */
    
}
