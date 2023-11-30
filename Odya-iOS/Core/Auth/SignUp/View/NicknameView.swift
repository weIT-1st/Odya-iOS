//
//  RegisterNickname.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/29.
//

import SwiftUI

/// 사용자 닉네임 입력 뷰
struct RegisterNicknameView: View {
  /// 닉네임 유효성 검사
  @StateObject var validatorApi = AuthValidatorApiViewModel()
  
  /// 회원가입 단계
  @Binding var signUpStep: Int
  
  /// 회원가입할 사용자 정보
  @Binding var userInfo: SignUpInfo
  
  /// 입력된 닉네임
  @State private var nickname: String = ""
  
  /// 닉네임 편집 여부
  private var isEditing: Bool {
    nickname != userInfo.nickname
  }
  
  /// 닉네임 유효성 여부 - 최소 2자~최대 8자, 특수문자 불가능
  private var isValid: Bool {
    UserInfoField.nickname.isValid(value: nickname)
  }
  
  /// 다음 단계로 넘어갈 수 있는지 여부
  /// 중복여부는 포함되지 않음
  private var isNextButtonActive: ButtonActiveSate {
    return (!nickname.isEmpty && isValid) ? .active : .inactive
  }
  
  @State private var isShowingInvalidNicknameAlert: Bool = false
  
  init(_ step: Binding<Int>, userInfo: Binding<SignUpInfo>) {
    self._signUpStep = step
    self._userInfo = userInfo
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(alignment: .leading, spacing: 0) {
        // title
        Text("오댜에서 활동할 \n이름을 알려주세요!")
          .h3Style()
          .foregroundColor(.odya.label.normal)
          .padding(.bottom, 20)
        
        // input section
        nicknameTextField
        
        // validation text
        nicknameValidationText
          .padding(10)
      }.padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      /// 다음 회원가입 단계로 넘어가는 버튼
      /// 중복된 닉네임이 있는지 검사 후 중복이 아니면 다음 단계로 넘어감
      /// 닉네임이 중복일 경우 alert를 띄움
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
      self.nickname = userInfo.nickname
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
  /// 닉네임 유효성(중복) 확인 함수
  /// 유효할 경우 다음 단계로 넘어가도록 signUpStep을 1증가시킴'
  /// 유효하지 않을 경우 alert flag를 킴
  func checkNickname() {
    validatorApi.validateNickname(nickname: nickname) { result in
      if result {
        self.userInfo.nickname = nickname
        self.signUpStep += 1
      } else {
        isShowingInvalidNicknameAlert = true
      }
    }
  }
}

//struct RegisterNicknameView_Previews: PreviewProvider {
//  static var previews: some View {
//    SignUpView()
//  }
//}
