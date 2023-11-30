//
//  KakaoLoginButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import SwiftUI

struct KakaoLoginButton: View {

  // MARK: PROPERTIES
  @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel

  // MARK: BODY
  var body: some View {
    VStack {
      // login button
      Button(action: {
        kakaoAuthVM.kakaoLogin()
      }) {
        HStack(alignment: .center, spacing: 10) {
          Spacer()
          if !kakaoAuthVM.isLoginInProgress {
            Image("kakao-icon")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 15)
            Text("카카오 로그인")
              .b1Style()
              .foregroundColor(.black)
          } else {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .odya.label.inactive))
          }
          Spacer()
        }
        .frame(height: 44)
        .background(Color("kakao-yellow"))
        .cornerRadius(Radius.small)
      }
    }
  }
}

// MARK: PREVIEWS
//struct KakaoLoginView_Previews: PreviewProvider {
//  static var previews: some View {
//    KakaoLoginButton()
//  }
//}
