//
//  AppleLoginButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/03.
//

import AuthenticationServices
import SwiftUI

/// 애플 로그인 버튼
struct AppleLoginButton: View {
//  @AppStorage("isAppleSignInValid") var isAppleSignInValid: Bool = AppleUserData.isValid

  @EnvironmentObject var appleAuthVM: AppleAuthViewModel

  var body: some View {
    SignInWithAppleButton { request in
      appleAuthVM.handleSignInWithAppleRequest(request)
    } onCompletion: { result in
      appleAuthVM.handleSignInWithAppleCompletion(result)
    }
    .frame(height: 44)
    .signInWithAppleButtonStyle(.white)
  }
}

struct AppleLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    AppleLoginButton()
  }
}
