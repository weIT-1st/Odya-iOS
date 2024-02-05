//
//  AppDelegate.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import UIKit
import GoogleMaps
import GooglePlaces
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseAuth

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    
    let gmsApiKey = String(describing: Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] ?? "")
    GMSPlacesClient.provideAPIKey(gmsApiKey)
    GMSServices.provideAPIKey(gmsApiKey)
    
    // firebase SDK 초기화
    FirebaseApp.configure()
    
    // kakao SDK 초기화
    KakaoSDK.initSDK(appKey: kakaoApiKey as! String)
    
    
    // Apple Sign In 상태 확인, 유효 여부 저장
    Task {
      AppleUserData.isValid = await AppleSignInManager.shared.checkIfLoginWithApple()
    }
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // 카카오 커스텀 스키마 리디렉션 URL을 처리
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    // 파이어베이스 커스텀 스키마 리디렉션 URL을 처리
    if Auth.auth().canHandle(url) {
      return true
    }
    
    return false
  }
  
  /// sceneDelegate 연결
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
    let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    
    sceneConfiguration.delegateClass = SceneDelegate.self
    
    return sceneConfiguration
  }
}
