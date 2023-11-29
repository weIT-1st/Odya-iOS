//
//  RegisterUserInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import SwiftUI

private struct SignUpIndicatorView: View {
  @Binding var step: Int
  
  var body: some View {
    VStack {
      backButton
      stepIndicator
    }
  }
  
  private var backButton: some View {
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

struct RegisterUserInfoView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel
  
  var signUpStep:  Int { signUpVM.step }

  var body: some View {
    VStack {
      SignUpIndicatorView(step: $signUpVM.step)
      
      Spacer()
      
      switch signUpStep {
      case 1:
        RegisterNicknameView($signUpVM.step,
                             userInfo: $signUpVM.userInfo)
      case 2:
        RegisterDefaultInfoView($signUpVM.step,
                                userInfo: $signUpVM.userInfo)
          .environmentObject(signUpVM)
      case 3:
        RegisterTopicsView($signUpVM.step,
                           userInfo: $signUpVM.userInfo)
      case 4:
        RegisterFollowsView()
          .environmentObject(signUpVM)
      default:
        Spacer()
        Text("kkk")
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
