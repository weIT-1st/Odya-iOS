//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

/// 사용자 정보를 입력받는 4단계에 대한 인디케이터
private struct SignUpIndicatorView: View {
  @Binding var step: Int
  
  var body: some View {
    VStack {
      backButton
      stepIndicator
    }
  }
  
  private var backButton: some View {
    // 첫 단계 제외 뒤로가기 버튼 표시
    // TODO: 회원가입 완료 후 토픽 뷰에서 뒤로가기 가능?
    HStack {
      Button( action: { step -= 1 }) {
        Text("뒤로가기")
          .detail2Style()
          .foregroundColor(step > 1 ? Color.odya.brand.primary : Color.odya.background.normal)
          .frame(height: 56)
      }.disabled(step == 1)
      Spacer()
    }.padding(.horizontal, GridLayout.side)
  }
  
  private var stepIndicator: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.odya.system.inactive)
        .frame(width: UIScreen.main.bounds.width, height: 6)
      
      let activeBarLength: CGFloat = (UIScreen.main.bounds.width / 4) * CGFloat(step)
      HStack(spacing: 0) {
        Rectangle()
          .foregroundColor(.odya.brand.primary)
          .frame(width: activeBarLength, height: 6)
        Spacer()
      }.animation(.easeInOut, value: activeBarLength)
    }
  }
}

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
