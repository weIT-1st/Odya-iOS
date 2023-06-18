//
//  SceneDelegate.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import UIKit
import SwiftUI
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @AppStorage("accessToken") var kakaoAccessToken: String?
    @AppStorage("isAppleSignInValid") var isAppleSignInValid: Bool = AppleUserData.isValid
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 애플로그인 후 실행 중 애플아이디 사용 중단한 경우
        if kakaoAccessToken == nil {
            Task {
                if await AppleSignInManager.shared.checkIfLoginWithApple() == false {
                    AppleUserData.isValid = false
                    isAppleSignInValid = false
                }
            }
        }
    }
    
}
