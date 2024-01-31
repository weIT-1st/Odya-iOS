//
//  RegisterUserInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/23.
//

import SwiftUI

struct RegisterUserInfoView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel
  @State var step: Int = 1
  
  var body: some View {
    VStack {
      SignUpIndicatorView(step: $step)
      
      if step == 1 { // 닉네임
        RegisterNicknameView($step,
                             userInfo: $signUpVM.userInfo)
      }
      else { // 생일 및 성별
        // 여기서 서버 계정 등록이 실행됨
        RegisterDefaultInfoView($step,
                                userInfo: $signUpVM.userInfo)
          .environmentObject(signUpVM)
      }
    }
  }
}
