//
//  RegisterUserInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
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

/// 회원가입에 필요한 사용자 정보를 입력받는 뷰
/// 닉네임, 생일 및 성별, 관심 토픽, 팔로우할 친구
/// 앱에서 제공되는 토픽들과 팔로우 가능한 친구 정보는 회원가입 이후에 접근 가능하므로
/// 생일 및 성별까지 입력 받은 후 서버에 사용자 등록(회원가입)을 실행함
struct RegisterUserInfoView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel
  
  /// 회원가입 단계
  var signUpStep:  Int { signUpVM.step }

  var body: some View {
    VStack {
      // 단계 인디케이터
      SignUpIndicatorView(step: $signUpVM.step)
      
      switch signUpStep {
      case 1: // 닉네임
        RegisterNicknameView($signUpVM.step,
                             userInfo: $signUpVM.userInfo)
      case 2: // 생일 및 성별
        // 여기서 서버 계정 등록이 실행됨
        RegisterDefaultInfoView($signUpVM.step,
                                userInfo: $signUpVM.userInfo)
          .environmentObject(signUpVM)
      case 3: // 관심 토픽
        RegisterTopicsView($signUpVM.step,
                           userInfo: $signUpVM.userInfo)
      case 4: // 팔로우 가능한 친구
        RegisterFollowsView($signUpVM.step,
                            userInfo: $signUpVM.userInfo)
      default:
        Spacer()
        Text("Error")
        Spacer()
      }
    }
  }  // body
}

struct RegisterUserInfoView_Preview: PreviewProvider {
  static var previews: some View {
    SignUpView(socialType: .unknown, signUpInfo: SignUpInfo())
  }
}
