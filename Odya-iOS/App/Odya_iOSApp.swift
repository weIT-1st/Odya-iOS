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
    
    
    // MARK: BODY
    
    var body: some Scene {
        WindowGroup {
            if let token = idToken {
                RootTabView()
                    .onAppear {
                        /// 토큰 갱신 및 유저 정보 가져오기
                        Task {
                            do {
                                if await appDataManager.refreshToken() {
                                    try await appDataManager.initMyData()
                                }
                            } catch {
                                print("Data initialzing failed with error:", error)
                            }
                        }
                    }
            } else {
                LoginView()
                    .environmentObject(appleAuthVM)
                    .environmentObject(kakaoAuthVM)
            }
        }
    }
    
}
