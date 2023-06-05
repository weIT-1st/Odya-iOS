//
//  SceneDelegate.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import Foundation
import UIKit
import KakaoSDKAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
}
