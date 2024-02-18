//
//  UserInfoEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/07.
//

import Foundation
import SwiftUI

private struct UserDeletionButton: View {
  @EnvironmentObject var VM: UserInfoEditViewModel
  @State private var isShowingUserDeletionAlert: Bool = false
  var body: some View {
    Button(action: {
      print("회원탈퇴 클릭")
      isShowingUserDeletionAlert = true
    }) {
      Text("회원탈퇴")
        .b1Style()
        .foregroundColor(.odya.system.warning)
    }
    .alert("정말 탈퇴하시겠습니까?", isPresented: $isShowingUserDeletionAlert) {
      Button("탈퇴", role: .destructive) {
        isShowingUserDeletionAlert = false
        VM.deleteUser()
      }
    }
  }
}

private struct LogoutButton: View {
  @EnvironmentObject var VM: UserInfoEditViewModel

  var body: some View {
    Button(
      action: {
        print("로그아웃 클릭")
        VM.logout()
      },
      label: {
        Text("로그아웃")
          .b1Style()
          .foregroundColor(.odya.label.normal)
      })
  }
}

// MARK: User Info Edit View

struct UserInfoEditView: View {
  @StateObject var VM = UserInfoEditViewModel()

  var body: some View {
    VStack {
      if VM.isDeletingUser {
        ProgressView()
      }
      
      else {
        CustomNavigationBar(title: "회원정보 수정")
        userInfoEditViewMainSection
      }
    }.background(Color.odya.background.normal)
  }

  var userInfoEditViewMainSection: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Section(
          header: Text("닉네임")
            .h6Style()
            .foregroundColor(.odya.label.normal)
        ) { NicknameEditSection().environmentObject(VM) }

        Divider().frame(height: 1).background(Color.odya.line.alternative)

        Section(
          header: Text("휴대폰 번호")
            .h6Style()
            .foregroundColor(.odya.label.normal)
        ) { PhoneNumberEditSection().environmentObject(VM) }

        Divider().frame(height: 1).background(Color.odya.line.alternative)

        Section(
          header: Text("이메일 주소")
            .h6Style()
            .foregroundColor(.odya.label.normal)
        ) { EmailEditSection().environmentObject(VM) }

        Divider().frame(height: 1).background(Color.odya.line.alternative)

        LogoutButton()
          .environmentObject(VM)

        Divider().frame(height: 1).background(Color.odya.line.alternative)

        UserDeletionButton()
          .environmentObject(VM)

      }  // main VStack
      .padding(GridLayout.side)

    }  // ScrollView
    .background(Color.odya.elevation.elev2)
  }
}

// MARK: Nickname Edit Section

struct NicknameEditSection: View {
  @EnvironmentObject var VM: UserInfoEditViewModel

  var userNickname: String {
    VM.nickname
  }
  @State private var newNickname: String = ""

  private var isEditing: Bool {
    userNickname != newNickname
  }
  private var isValid: Bool {
    UserInfoField.nickname.isValid(value: newNickname)
  }

  @State var isShowAlert: Bool = false
  @State var alertMessage: String = ""

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        UserInfoTextField(
          info: userNickname,
          newInfo: $newNickname,
          infoField: .nickname)
        UserInfoEditButton(
          buttonText: "변경",
          isActive: isEditing && isValid
        ) {
          VM.updateNickname(newNickname) { (success, msg) in
            if success {
              alertMessage = "변경되었습니다"
              isShowAlert = true
              VM.nickname = newNickname
            } else {
              alertMessage = msg
              isShowAlert = true
            }
          }
        }.alert(alertMessage, isPresented: $isShowAlert) {
          Button("확인", role: .cancel) {}
        }
      }

      if !isEditing {
        Text("*최소 2자~최대 8자, 특수문자 불가능")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .padding(.horizontal, 10)
      } else {
        HStack(spacing: 0) {
          Image(isValid ? "system-check-circle" : "system-warning")
            .padding(.trailing, 8)
          Text(isValid ? "사용할 수 있는 닉네임입니다" : "*최소 2자~최대 8자, 특수문자 불가능")
            .detail2Style()
            .foregroundColor(isValid ? .odya.system.safe : .odya.system.warning)
        }.padding(.horizontal, 10)
      }
    }
    .onChange(of: userNickname) { newValue in
      newNickname = newValue
    }
  }
}  // NicknameEditSection

// MARK: Phonenumber Edit Section

struct PhoneNumberEditSection: View {
  @EnvironmentObject var VM: UserInfoEditViewModel
  var userPhoneNumber: String? {
    VM.phoneNumber
  }
  @State private var newPhoneNumber: String = ""
  @State private var verificationCode: String = ""

  private var isEditing: Bool {
    newPhoneNumber != "" && userPhoneNumber != newPhoneNumber
  }
  private var isValid: Bool {
    UserInfoField.phoneNumber.isValid(value: newPhoneNumber)
  }
  private var isVerificationButtonActive: Bool {
    VM.isVerificationInProgress && !verificationCode.isEmpty
  }
  
  @State var isVerificationButtonClicked : Bool = false

  @State var isShowAlert: Bool = false
  @State var alertMessage: String = ""
  @State var isGettingVerificationCode: Bool = false

  @StateObject var validatorApi = AuthValidatorApiViewModel()

  var body: some View {
    VStack(spacing: 16) {
      HStack {  // 휴대폰 번호 변경
        UserInfoTextField(
          info: userPhoneNumber ?? "",
          newInfo: $newPhoneNumber,
          infoField: .phoneNumber)
        
        UserInfoEditButton(
          buttonText: "변경",
          isActive: isEditing && isValid && !isGettingVerificationCode
        ) {
          validatorApi.validatePhonenumber(phoneNumber: newPhoneNumber) { result in
            if result {
              // 인증 번호 전송
              VM.getVerificationCode(newNumber: newPhoneNumber) { success in
                alertMessage = success ? "인증번호가 발송 되었습니다." : "인증에 실패하였습니다. 다시 시도해주세요."
                isShowAlert = true
              }
            } else {
              alertMessage = "이미 존재하는 번호입니다"
              isShowAlert = true
              newPhoneNumber = userPhoneNumber ?? ""
            }
            isGettingVerificationCode = false
          }
        }.alert(alertMessage, isPresented: $isShowAlert) { Button("확인", role: .cancel) {} }
      }
      
      if VM.isVerificationInProgress {
        HStack {  // 인증번호 입력
          TextField("인증번호를 입력해주세요", text: $verificationCode)
            .foregroundColor(.odya.label.normal)
            .b1Style()
            .modifier(CustomFieldStyle())
          
          // TODO: 인증번호 확인 버튼 활성화 조건 체크
          UserInfoEditButton(
            buttonText: "확인",
            isActive: true
          ) {
            isVerificationButtonClicked = true
            // TODO: 인증번호 확인절차
            VM.verifyAndUpdatePhoneNumber(verificationCode: verificationCode) { success in
              alertMessage = success ? "인증되었습니다.\n휴대폰 번호가 \(newPhoneNumber)으로 변경되었습니다" : "인증에 실패하였습니다. 다시 시도해주세요."
              if success {
                VM.phoneNumber = newPhoneNumber
              } else {
                newPhoneNumber = userPhoneNumber ?? ""
              }
              isShowAlert = true
              verificationCode = ""
            }
          }
          .disabled(!isVerificationButtonActive || isVerificationButtonClicked)
        }.animation(.easeInOut, value: VM.isVerificationInProgress)
      }
    }.onChange(of: userPhoneNumber) { newValue in
      newPhoneNumber = newValue ?? ""
    }
    
  }
}  // PhoneNumberEditSection

// MARK: Email Edit Section

struct EmailEditSection: View {
  @EnvironmentObject var VM: UserInfoEditViewModel
  var userEmail: String? {
    VM.email
  }
  @State private var newEmail: String = ""
  @State private var newEmailDomain: String = ""

  private var isEditing: Bool {
    newEmail != "" && userEmail != newEmail
  }
  private var isValid: Bool {
    UserInfoField.email.isValid(value: newEmail)
  }

  @State var isShowAlert: Bool = false
  @State var alertMessage: String = ""

  @StateObject var validatorApi = AuthValidatorApiViewModel()

  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      UserInfoTextField(
        info: userEmail ?? "",
        newInfo: $newEmail,
        infoField: .email)

      HStack {  // 이메일 도메인
        Menu {
          Button("@naver.com") {
            newEmailDomain = "@naver.com"
            let components = newEmail.components(separatedBy: "@")
            newEmail = components[0] + newEmailDomain
          }
          Button("@gmail.com") {
            newEmailDomain = "@gmail.com"
            let components = newEmail.components(separatedBy: "@")
            newEmail = components[0] + newEmailDomain
          }
          Button("@daum.net") {
            newEmailDomain = "@daum.net"
            let components = newEmail.components(separatedBy: "@")
            newEmail = components[0] + newEmailDomain
          }
          Button("직접입력") {
            newEmailDomain = ""
            let components = newEmail.components(separatedBy: "@")
            newEmail = components[0] + newEmailDomain
          }
        } label: {
          HStack(spacing: 0) {
            Text(newEmailDomain == "" ? "직접입력" : newEmailDomain)
              .b1Style()
              .foregroundColor(newEmailDomain == "" ? .odya.label.inactive : .odya.label.normal)

            Spacer()
            Image("direction-down")
              .padding(.horizontal, 6)
          }
          .modifier(CustomFieldStyle())
        }

        UserInfoEditButton(
          buttonText: "변경",
          isActive: isEditing && isValid
        ) {
          validatorApi.validateEmail(email: newEmail) { result in
            if result {
              VM.verifyEmailAddress(address: newEmail) { (success, msg) in
                alertMessage = msg
                isShowAlert = true
                if !success {
                  newEmail = userEmail ?? ""
                  newEmailDomain = ""
                }
              }
            } else {
              alertMessage = "이미 존재하는 이메일입니다"
              isShowAlert = true
              newEmail = userEmail ?? ""
              newEmailDomain = ""
            }
          }
        }.alert(alertMessage, isPresented: $isShowAlert) { Button("확인", role: .cancel) {} }
      }

    }.onChange(of: userEmail) { newValue in
      newEmail = newValue ?? ""
    }
    
    if VM.isEmailVerificationInProgress {
      HStack {
        Spacer()
        CTAButton(isActive: .active,
                  buttonStyle: .solid,
                  labelText: "인증완료",
                  labelSize: .L) {
          VM.verifyAndUpdateEmailAddress() { (success, msg) in
            alertMessage = msg
            if success {
              VM.email = newEmail
              newEmailDomain = ""
            } else if msg != "이메일 주소가 아직 인증되지 않았습니다. 이메일을 확인해주세요." {
              newEmail = userEmail ?? ""
              newEmailDomain = ""
            }
            isShowAlert = true
          }
        }
        Spacer()
      }
    }
  }
}

// MARK: Preview
//struct UserInfoEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfoEditView(userInfo: UserInfo(nickname: "길동아밥먹자"))
//    }
//}
