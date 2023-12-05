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

  var body: some View {
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
          .environmentObject(kakaoAuthVM)
        AppleLoginButton()
          .environmentObject(appleAuthVM)
      }.padding(.bottom, 60)
      
    }.padding(.horizontal, GridLayout.side)
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    LoginView()
//  }
//}
