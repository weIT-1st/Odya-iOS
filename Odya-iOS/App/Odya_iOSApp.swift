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
    @StateObject private var alertManager = AlertManager()
    
    @AppStorage("WeITAuthToken") var idToken: String?
    @AppStorage("WeITAuthType") var authType: String = ""
    
    
    // MARK: BODY
    
    var body: some Scene {
        WindowGroup {
            if let token = idToken {
                RootTabView()
                    .environmentObject(alertManager)
                    .onAppear {
                        /// 토큰 갱신 및 유저 정보 가져오기
                        Task {
                            appDataManager.refreshToken() { success in
                                if success {
                                    appDataManager.initMyData()
                                }
                            }
                        }
                        /// 탭해서 키보드 내리기
                        UIApplication.shared.hideKeyboardOnTap()
                    }
                    .alert("여행일지가 등록되었습니다.", isPresented: $alertManager.showAlertOfTravelJournalCreation) {
                        Button("확인") {
                            alertManager.showAlertOfTravelJournalCreation = false
                        }
                    }
                    .alert("여행일지 등록에 실패하였습니다.", isPresented: $alertManager.showFailureAlertOfTravelJournalCreation) {
                        Button("확인") {
                            alertManager.showFailureAlertOfTravelJournalCreation = false
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
