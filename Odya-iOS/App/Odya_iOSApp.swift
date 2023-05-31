//
//  Odya_iOSApp.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI

@main
struct Odya_iOSApp: App {
    
    // with AppDelegate.swift
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            KakaoLoginView()
            // LoginView()
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
