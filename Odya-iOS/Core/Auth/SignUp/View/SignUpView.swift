//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct SignUpView: View {

  // @AppStorage("WeITAuthToken") var idToken: String?

  @EnvironmentObject var appleAuthVM: AppleAuthViewModel
  @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel
  @ObservedObject private var signUpVM: SignUpViewModel
  @StateObject private var authApi = AuthViewModel()

  var step : Int { signUpVM.step }
  @Binding var isUnauthorized: Bool
  
  
  init(socialType: SocialLoginType,
       signUpInfo: SignUpInfo,
       isUnauthorized: Binding<Bool>) {
    self.signUpVM = SignUpViewModel(socialType: socialType, userInfo: signUpInfo)
    self._isUnauthorized = isUnauthorized
  }
  
  var body: some View {
    ZStack {
      Color.odya.background.normal.ignoresSafeArea()

      // contents
      switch step {
      case -1:
        AppIntroductionView($signUpVM.step)
      case 0:
        TermsView($signUpVM.step,
                  myTermsIdList: $signUpVM.userInfo.termsIdList)
      case 1...4:
        RegisterUserInfoView()
          .environmentObject(signUpVM)
      case 5:
        MainLoadingView()
          .onAppear {
            /// 로딩화면 타이머
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
              isUnauthorized = false
            })
          }
      default:
        LoginView()
      }
    }  // background color ZStack
  }  // body
}

//struct SignUpView_Preview: PreviewProvider {
//  static var previews: some View {
//    SignUpView(socialType: .unknown, signUpInfo: SignUpInfo(), isUnauthorized: .constant(true))
//  }
//}
