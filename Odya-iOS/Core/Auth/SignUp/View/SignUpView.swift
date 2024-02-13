//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

enum SignUpStep {
  case appIntro
  case terms
  case userInfo
  case loading
  
  mutating func nextStep() {
    switch self {
    case .appIntro:
      self = .terms
    case .terms:
      self = .userInfo
    case .userInfo:
      self = .loading
    case .loading:
      self = .loading
    }
  }
}

struct SignUpView: View {

  @ObservedObject private var signUpVM: SignUpViewModel
  
  /// 계정 상태, 오류 발생 시 로그인 페이지로 이동하기 위함
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedOut

  /// 회원가입 단계
  var step: SignUpStep { signUpVM.step }
  
  // MARK: Init
  
  // apple
  init(signUpInfo: SignUpInfo) {
    self.signUpVM = SignUpViewModel(userInfo: signUpInfo)
  }
  
  // kakao
  init(signUpInfo: SignUpInfo, kakaoAccessToken: String) {
    self.signUpVM = SignUpViewModel(userInfo: signUpInfo, kakaoAccessToken: kakaoAccessToken)
  }
  
  // MARK: Body
  var body: some View {
    ZStack {
      Color.odya.background.normal.ignoresSafeArea()
      
      // contents
      switch step {
      case .appIntro:
        AppIntroductionView($signUpVM.step)
      case .terms:
        TermsView($signUpVM.step,
                  myTermsIdList: $signUpVM.userInfo.termsIdList)
      case .userInfo:
        RegisterUserInfoView()
          .environmentObject(signUpVM)
      case .loading:
        MainLoadingView()
          .onAppear {
            /// 로딩화면 타이머
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
              if signUpVM.authorized {
                
                // nickname -> additonal Set Up View 에서 사용됨
                MyData.nickname = signUpVM.userInfo.nickname
                
                signUpVM.idToken = signUpVM.userInfo.idToken
                AppDataManager().initMyData() { _ in }
                
                self.authState = .additionalSetupRequired
              }
            })
          }
        // TODO: 고민 거리....!
        // 카카오 회원가입 시 회원가입 완료 후 로그인도 진행, 애플 회원가입보다 시간이 오래 걸림
        // -> 로딩화면 타이머가 끝나기 전까지 authorized 값이 안변할 수 있음
        // BUT!! 애플 회원가입의 경우 타이머가 끝나는 것보다 authorized 값이 변하는 게 빠름
        // -> 애플 회원가입 시 로딩화면 짧게 노출됨....
          .onChange(of: signUpVM.authorized) { newValue in
            if newValue == true && self.authState == .unauthorized {
              // nickname -> additonal Set Up View 에서 사용됨
              MyData.nickname = signUpVM.userInfo.nickname
              
              signUpVM.idToken = signUpVM.userInfo.idToken
              AppDataManager().initMyData() { _ in }
              
              self.authState = .additionalSetupRequired
            }
          }
      }
    }  // background color ZStack
  }  // body
}

//struct SignUpView_Preview: PreviewProvider {
//  static var previews: some View {
//    SignUpView(socialType: .unknown, signUpInfo: SignUpInfo(), isUnauthorized: .constant(true))
//  }
//}
