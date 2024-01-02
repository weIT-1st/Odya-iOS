//
//  AdditionalSetUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/05.
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
          .foregroundColor(step != 3 ? Color.odya.brand.primary : Color.odya.background.normal)
          .frame(height: 56)
      }.disabled(step <= 3)
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

// MARK: Additional SetUp View

/// 회원가입 완료 후 관심토픽, 팔로잉 친구를 설정하는 부분
struct AdditionalSetUpView: View {

  /// 계정 상태, 모든 정보를 설정 완료 후 로그인 상태로 변경
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedOut
  
  /// 단계, 회원가입 인데케이터에서 사용
  @State private var step: Int  = 3
  
  /// 사용자 닉네임
  @State private var nickname: String = MyData().nickname
  
  // MARK: Body
  var body: some View {
//    ZStack {
//      Color.odya.background.normal.ignoresSafeArea()

      // contents
      switch step {
      case 3, 4:
        VStack {
          SignUpIndicatorView(step: $step)
          
          if step == 3 {
            RegisterTopicsView($step,
                               nickname: nickname)
          } else {
            RegisterFollowsView($step,
                                nickname: nickname)
          }
        }
      case 5:
        MainLoadingView()
          .onAppear {
            /// 로딩화면 타이머
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
              self.authState = .loggedIn
            })
          }
      default:
        LoginView()
          .onAppear {
            self.authState = .loggedOut
          }
      }
//    }  // background color ZStack
  }  // body
}

//struct SignUpView_Preview: PreviewProvider {
//  static var previews: some View {
//    SignUpView(socialType: .unknown, signUpInfo: SignUpInfo(), isUnauthorized: .constant(true))
//  }
//}
