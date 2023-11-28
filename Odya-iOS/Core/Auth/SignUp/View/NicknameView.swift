//
//  RegisterNickname.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/29.
//

import SwiftUI

struct RegisterNicknameView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel
  @StateObject var validatorApi = AuthValidatorApiViewModel()
  
  @State private var nickname: String = ""
  
  private var isEditing: Bool {
    nickname != signUpVM.nickname
  }
  private var isValid: Bool {
    UserInfoField.nickname.isValid(value: nickname)
  }
  
  private var isNextButtonActive: ButtonActiveSate {
    return (!nickname.isEmpty && isValid) ? .active : .inactive
  }
  
  @State private var isShowingInvalidNicknameAlert: Bool = false
  
  var body: some View {
    VStack {
      Spacer()
      
      // input section
      VStack(alignment: .leading, spacing: 0) {
        Text("오댜에서 활동할 \n이름을 알려주세요!")
          .h3Style()
          .foregroundColor(.odya.label.normal)
          .padding(.bottom, 20)
        nicknameTextField
        nicknameValidationText
          .padding(10)
      }.padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      // next button
      CTAButton( isActive: isNextButtonActive, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        checkNickname()
      }
      .padding(.bottom, 45)
      .alert("이미 사용 중인 닉네임입니다.", isPresented: $isShowingInvalidNicknameAlert) {
        Button("확인") {
          nickname = ""
          isShowingInvalidNicknameAlert = false
        }
      }
    }
    .onAppear {
      self.nickname = signUpVM.nickname
    }
  }  // body
  
  /// 닉네임 입력 부분
  private var nicknameTextField: some View {
    VStack(alignment: .leading, spacing: 4) {
      // 닉네임 텍스트 필드
      HStack(spacing: 0) {
        TextField("", text: $nickname, prompt: Text("홍길동").foregroundColor(.odya.label.inactive))
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .frame(maxWidth: .infinity)
        IconButton("smallGreyButton-x") {
          nickname = ""
        }
      }.modifier(CustomFieldStyle())
    }
  }
  
  /// 사용가능한 닉네임인지 보여주는 문구
  private var nicknameValidationText: some View {
    HStack(spacing: 0) {
      if !isEditing {
        Text("*최소 2자~최대 8자, 특수문자 불가능")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
      } else {
        Image(isValid ? "system-check-circle": "system-warning")
          .padding(.trailing, 8)
        Text(isValid ? "사용할 수 있는 닉네임입니다" : "*최소 2자~최대 8자, 특수문자 불가능")
          .detail2Style()
          .foregroundColor(isValid ? .odya.system.safe : .odya.system.warning)
      }
    }
  }
}
  
extension RegisterNicknameView {
  func checkNickname() {
    validatorApi.validateNickname(nickname: nickname) { result in
      if result {
        self.signUpVM.nickname = nickname
        self.signUpVM.step += 1
      } else {
        isShowingInvalidNicknameAlert = true
      }
    }
  }
}

struct RegisterNicknameView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
