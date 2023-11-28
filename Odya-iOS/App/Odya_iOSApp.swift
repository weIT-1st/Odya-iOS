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
  
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  @StateObject private var appleAuthVM = AppleAuthViewModel()
  @StateObject private var kakaoAuthVM = KakaoAuthViewModel()
  @StateObject private var appDataManager = AppDataManager()
  
  @AppStorage("WeITAuthToken") var idToken: String?
  @AppStorage("WeITAuthType") var authType: String = ""
  
  @State private var isReady: Bool = false
  
  
  // MARK: BODY
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        
        SplashView()
        
        if isReady {
          if idToken != nil {
            RootTabView()
          } else {
            LoginView()
              .environmentObject(appleAuthVM)
              .environmentObject(kakaoAuthVM)
          }
        }
        
      } // Zstack
      .onAppear {
        /// 토큰 갱신 및 유저 정보 가져오기
        if idToken != nil {
          Task {
            appDataManager.refreshToken() { success in
              if success {
                appDataManager.initMyData()
              }
            }
          }
        }
        
        /// 탭해서 키보드 내리기
        UIApplication.shared.hideKeyboardOnTap()
        
        /// 스플래시 타이머
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
          isReady.toggle()
        })
      }
      .animation(.easeInOut, value: isReady)
    } // WithGroup
  }
  
}
