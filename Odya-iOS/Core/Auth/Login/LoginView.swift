//
//  LoginView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI

enum SocialLoginType {
  case kakao
  case apple
  case unknown
}

struct LoginView: View {
  @EnvironmentObject var appleAuthVM: AppleAuthViewModel
  @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel
  
  @State private var loginType: SocialLoginType = .unknown

  var body: some View {
    ZStack {
      Color.odya.background.normal.ignoresSafeArea()
      
      // 회원가입이 되어 있는 상태
      VStack {
        Spacer()
        Image("odya-logo-l")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 105)
        Spacer()
        
        // 로그인 버튼
        VStack(alignment: .center, spacing: 8) {
          KakaoLoginButton()
          AppleLoginButton()
        }.padding(.bottom, 60)
        
      }.padding(.horizontal, GridLayout.side)
      
      // 카카오로 회원가입
      if kakaoAuthVM.isUnauthorized {
        SignUpView(socialType: .kakao, signUpInfo: kakaoAuthVM.userInfo)
      }
      
      // apple로 회원가입
      if appleAuthVM.isUnauthorized {
        SignUpView(socialType: .apple, signUpInfo: appleAuthVM.userInfo)
      }
    } // ZStack
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
