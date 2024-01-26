//
//  Odya_iOSApp.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI
import KakaoSDKUser

enum AuthState: String {
  case loggedIn = "loggenIn"
  case loggedOut = "loggedOut"
  case unauthorized = "unauthorized"
  case additionalSetupRequired = "additionalSetupRequired"
}

@main
struct Odya_iOSApp: App {
//<<<<<<< HEAD
//
//    // MARK: PROPERTIES
//
//    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
//
//    @StateObject private var appleAuthVM = AppleAuthViewModel()
//    @StateObject private var kakaoAuthVM = KakaoAuthViewModel()
//    @StateObject private var appDataManager = AppDataManager()
//    @StateObject private var alertManager = AlertManager()
//
//    @AppStorage("WeITAuthToken") var idToken: String?
//    @AppStorage("WeITAuthType") var authType: String = ""
//
//
//    // MARK: BODY
//
//    var body: some Scene {
//        WindowGroup {
//            if let token = idToken {
//                RootTabView()
//                    .environmentObject(alertManager)
//                    .onAppear {
//                        /// 토큰 갱신 및 유저 정보 가져오기
//                        Task {
//                            appDataManager.refreshToken() { success in
//                                if success {
//                                    appDataManager.initMyData()
//                                }
//                            }
//                        }
//                        /// 탭해서 키보드 내리기
//                        UIApplication.shared.hideKeyboardOnTap()
//                    }
//                    .alert("여행일지가 등록되었습니다.", isPresented: $alertManager.showAlertOfTravelJournalCreation) {
//                        Button("확인") {
//                            alertManager.showAlertOfTravelJournalCreation = false
//                        }
//                    }
//                    .alert("여행일지 등록에 실패하였습니다.", isPresented: $alertManager.showFailureAlertOfTravelJournalCreation) {
//                        Button("확인") {
//                            alertManager.showFailureAlertOfTravelJournalCreation = false
//                        }
//                    }
//            } else {
//                LoginView()
//                    .environmentObject(appleAuthVM)
//                    .environmentObject(kakaoAuthVM)
//            }
//=======
  
  // MARK: PROPERTIES
  
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  @StateObject private var appleAuthVM = AppleAuthViewModel()
  @StateObject private var kakaoAuthVM = KakaoAuthViewModel()
  @StateObject private var appDataManager = AppDataManager()
  
  @AppStorage("WeITAuthType") var authType: String = ""
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedOut
  
  @State private var isReady: Bool = false

  // MARK: BODY
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        Color.odya.background.normal.ignoresSafeArea()
        
        // splash
        if !isReady {
          SplashView()
        }
        
        // 스플래시 뷰 끝난 후
        else {
          switch authState {
          // 로그인 완료 상태
          case .loggedIn:
            RootTabView()
            
          // 로그아웃 상태, 로그인 버튼 뷰 나옴
          case .loggedOut:
            LoginView()
              .environmentObject(appleAuthVM)
              .environmentObject(kakaoAuthVM)
            
          // 회원가입
          case .unauthorized:
            if appDataManager.idToken == nil {
              if authType == "kakao" {
                SignUpView(signUpInfo: kakaoAuthVM.userInfo, kakaoAccessToken: kakaoAuthVM.kakaoAccessToken)
              } else if authType == "apple" {
                SignUpView(signUpInfo: appleAuthVM.userInfo)
              }
            } else {
              ProgressView()
            }
            
          case .additionalSetupRequired:
            AdditionalSetUpView()
          }
        } // if ready
        
      } // Zstack
      .onAppear {
        /// 자동로그인
        if appDataManager.idToken != nil {
          if authState != .additionalSetupRequired {
            authState = .loggedIn
          }
          // 토큰 갱신 및 유저 정보 가져오기
          appDataManager.refreshToken() { success in
            if success {
              appDataManager.initMyData() { _ in }
            }
          }
        } else {
          authState = .loggedOut
          authType = ""
        }
            
        /// 탭해서 키보드 내리기
        UIApplication.shared.hideKeyboardOnTap()
        
        /// 스플래시 타이머
        if !isReady {
          DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isReady.toggle()
          })
        }
      }
      .animation(.easeInOut, value: isReady)
    } // WithGroup
  }
  
}
