//
//  Odya_iOSApp.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import Foundation
import SwiftUI
import AuthenticationServices
import KakaoSDKUser

@main
struct Odya_iOSApp: App {
    // MARK: PROPERTIES
    
    // with AppDelegate.swift
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    /// 카카오 자동로그인 확인을 위한 토큰
    @AppStorage("accessToken") var kakaoAccessToken: String?
  
    // TODO: - 생성자 내부의 애플로그인 상태 확인 코드를 Appdelegate의 didFinishLaunchingWithOptions, applicationDidBecomeActive에서 모두 실행하도록 변경
    init() {
        /// 애플 로그인 상태확인
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: AppleUserData.userIdentifier) { credentialState, error in
            switch credentialState {
            case .authorized:
                // 유효한 Apple ID Credential (인증성공)
                debugPrint("DEBUG: Apple ID is authorized")
            case .revoked:
                // 인증만료
                debugPrint("DEBUG: Apple ID is revoked")
            case .notFound:
                debugPrint("DEBUG: Apple ID is not found")
            default:
                break
            }
        }
    }
    
    // TODO: - 로그인 로직 수정
 
    // MARK: BODY

    var body: some Scene {
        WindowGroup {
            if kakaoAccessToken != nil {
                MainView()
            } else {
                KakaoLoginView()
            }
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
