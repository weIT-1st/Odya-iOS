//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct SignUpView: View {

  @ObservedObject private var signUpVM: SignUpViewModel
  
  /// 계정 상태, 오류 발생 시 로그인 페이지로 이동하기 위함
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedOut

  /// 회원가입 단계
  var step : Int { signUpVM.step }
  
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
      case -1:
        AppIntroductionView($signUpVM.step)
      case 0:
        TermsView($signUpVM.step,
                  myTermsIdList: $signUpVM.userInfo.termsIdList)
      case 1, 2:
        VStack {
          SignUpIndicatorView(step: $signUpVM.step)
          
          if step == 1 { // 닉네임
            RegisterNicknameView($signUpVM.step,
                                 userInfo: $signUpVM.userInfo)
          }
          else { // 생일 및 성별
            // 여기서 서버 계정 등록이 실행됨
            RegisterDefaultInfoView($signUpVM.step,
                                    userInfo: $signUpVM.userInfo)
            .environmentObject(signUpVM)
          }
        }
      case 3:
        MainLoadingView()
          .onAppear {
            /// 로딩화면 타이머
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
              self.authState = .additionalSetupRequired
            })
          }
      default:
        LoginView()
          .onAppear{
            authState = .loggedOut
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
