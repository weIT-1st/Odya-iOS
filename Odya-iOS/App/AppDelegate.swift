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
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: did Finish Launching
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // MARK: -- Keys
    let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    
    let gmsApiKey = String(describing: Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] ?? "")
    GMSPlacesClient.provideAPIKey(gmsApiKey)
    GMSServices.provideAPIKey(gmsApiKey)
    
    // MARK: -- Firbase
    // firebase SDK 초기화
    FirebaseApp.configure()
    
    // MARK: -- FCM Noti
    
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    
  
    // 메세징 델리겟, 메시지 대리자 설정
    Messaging.messaging().delegate = self
    
    
    // MARK: -- Kakao
    
    // kakao SDK 초기화
    KakaoSDK.initSDK(appKey: kakaoApiKey as! String)
    
    // MARK: Apple Sign In
    // Apple Sign In 상태 확인, 유효 여부 저장
    Task {
      AppleUserData.isValid = await AppleSignInManager.shared.checkIfLoginWithApple()
    }
    
    return true
  }
  
  // MARK: Kakao Login
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    return false
  }
  
  // MARK: register FCM token
  /// FCM 토큰이 등록 되었을 때, apns 토큰이랑 연결시켜줌
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  /// fcm 토큰 등록 실패
  func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Remote notification is unavailable: \(error.localizedDescription)")
  }
  
  // MARK: SceneDelegate
  /// sceneDelegate 연결
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
    let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    
    sceneConfiguration.delegateClass = SceneDelegate.self
    
    return sceneConfiguration
  }
}

extension AppDelegate: MessagingDelegate {

  // FCM 등록 토큰을 받았을 떄, 토큰 갱신 모니터링
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("AppDelegate - fcm 토큰 받음")
    print("AppDelegate = token: \(String(describing: fcmToken ))")
    if let fcmToken = fcmToken {
      NotiManager().updateFCMToken(newToken: fcmToken)
    } else {
      print("fcm token error: token is invalid")
    }

  }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
  // 포그라운드에서 푸시 메시지를 받았을 때
  // 백그라운드에서 올 때는...? (알림 뜨는 건 확인)
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print("willPresent: \(userInfo)")
    completionHandler([.banner, .sound, .badge])
  }

  // 푸시메시지를 받았을 때, 알림을 클릭했을 때 호출됨
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("didRequest \(userInfo)")
    completionHandler()
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("didReceiveRemoteNotification \(userInfo)")
    completionHandler(.noData)
  }
}
