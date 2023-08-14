//
//  UserInfoEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/07.
//

import SwiftUI
import Foundation
    
struct UserInfoEditView: View {
    @State var userInfo: UserInfo
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "회원정보 수정")
            userInfoEditViewMainSection
        }.background(Color.odya.background.normal)
    }
    
    var userInfoEditViewMainSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Section(header: Text("닉네임")
                            .h6Style()
                            .foregroundColor(.odya.label.normal))
                { NicknameEditSection($userInfo.nickname) }
                
                Divider().frame(height: 1).background(Color.odya.line.alternative)
                
                Section(header: Text("휴대폰 번호")
                            .h6Style()
                            .foregroundColor(.odya.label.normal))
                { PhoneNumberEditSection($userInfo.phoneNumber) }

                Divider().frame(height: 1).background(Color.odya.line.alternative)

                Section(header: Text("이메일 주소")
                            .h6Style()
                            .foregroundColor(.odya.label.normal))
                { EmailEditSection($userInfo.email) }

                Divider().frame(height: 1).background(Color.odya.line.alternative)
                
                Button(action: {
                    print("로그아웃 클릭")
                    // TODO: 카카오 로그아웃 기능 연결
                    // TODO: 애플 로그아웃 구현 및 연결
                }, label: {
                    Text("로그아웃")
                        .b1Style()
                        .foregroundColor(.odya.label.normal)
                })
                
                Divider().frame(height: 1).background(Color.odya.line.alternative)
                
                Button(action: {
                    print("회원탈퇴 클릭")
                    // TODO: 회원탈퇴 기능 구현 및 연결
                }, label: {
                    Text("회원탈퇴")
                        .b1Style()
                        .foregroundColor(.odya.system.warning)
                })
                
            } // main VStack
            .padding(GridLayout.side)
        } // ScrollView
        .background(Color.odya.elevation.elev2)
    }
}

struct NicknameEditSection: View {
    @Binding var userNickname: String
    @State private var newNickname: String
    private var isEditing: Bool {
        userNickname != newNickname
    }
    private var isValid: Bool {
        UserInfoField.nickname.isValid(value: newNickname)
    }

    init(_ nickname: Binding<String>) {
        self._userNickname = nickname
        self._newNickname = State(initialValue: nickname.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                UserInfoTextField(info: userNickname,
                                  newInfo: $newNickname,
                                  infoField: .nickname)
                UserInfoEditButton(buttonText: "변경",
                                   isActive: isEditing) {
                    // TODO: 닉네임 중복 확인 기능 구현
                    
                    // 변경 가능하면 (중복이 아니고 유효하면)
                    if isValid {
                        // 닉네임 변경 api
                        userNickname = newNickname
                    }
                    // 변경 불가능하면
                    // alert
                }
            }
            
            if !isEditing {
                Text("*최소 2자~최대 8자, 특수문자 불가능")
                    .detail2Style()
                    .foregroundColor(.odya.label.normal)
                    .padding(.horizontal, 10)
            } else {
                HStack(spacing: 0) {
                    Image(isValid ? "system-check-circle": "system-warning")
                        .padding(.trailing, 8)
                    Text(isValid ? "사용할 수 있는 닉네임입니다" : "*최소 2자~최대 8자, 특수문자 불가능")
                        .detail2Style()
                        .foregroundColor(isValid ? .odya.system.safe : .odya.system.warning)
                }.padding(.horizontal, 10)
            }
        }
    }
} // NicknameEditSection

struct PhoneNumberEditSection: View {
    @Binding var userPhoneNumber: String?
    @State private var newPhoneNumber: String?
    @State private var verificationCode: String = ""
    
    private var isEditing: Bool {
        newPhoneNumber != nil && newPhoneNumber != "" && userPhoneNumber != newPhoneNumber
    }
    private var isValid: Bool {
        UserInfoField.phoneNumber.isValid(value: newPhoneNumber ?? "")
    }

    init(_ phoneNumber: Binding<String?>) {
        self._userPhoneNumber = phoneNumber
        self._newPhoneNumber = State(initialValue: phoneNumber.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack { // 휴대폰 번호 변경
                UserInfoTextField(info: userPhoneNumber ?? "",
                                  newInfo: $newPhoneNumber.toUnwrapped(defaultValue: ""),
                                  infoField: .phoneNumber)

                UserInfoEditButton(buttonText: "변경",
                                   isActive: isEditing) {
                    // TODO: 폰번호 중복 확인 기능 구현

                    // 변경 가능하면 (중복이 아니고 유효하면)
                    if isValid {
                        // 닉네임 변경 api
                        userPhoneNumber = newPhoneNumber
                    }
                    // 변경 불가능하면
                    // alert
                }
            }

            HStack { // 인증번호 입력
                TextField("인증번호를 입력해주세요", text: $verificationCode)
                    .foregroundColor(verificationCode == "" ? .odya.label.inactive : .odya.label.normal)
                    .b1Style()
                    .frame(maxWidth: .infinity)
                    .modifier(CustomFieldStyle())

                // TODO: 인증번호 확인 버튼 활성화 조건 체크
                UserInfoEditButton(buttonText: "확인",
                                   isActive: true) {
                    // TODO: 인증번호 확인절차
                }
            }
        }
    }
} // PhoneNumberEditSection

struct EmailEditSection: View {
    @Binding var userEmail: String?
    @State private var newEmail: String
    @State private var newEmailDomain: String = ""

    private var isEditing: Bool {
        newEmail != "" && userEmail != newEmail
    }
    private var isValid: Bool {
        UserInfoField.email.isValid(value: newEmail)
    }

    init(_ email: Binding<String?>) {
        self._userEmail = email
        self._newEmail = State(initialValue: email.wrappedValue ?? "")
    }

    var body: some View {
        VStack(spacing: 16) {
            UserInfoTextField(info: userEmail ?? "",
                              newInfo: $newEmail,
                              infoField: .email)

            HStack { // 이메일 도메인
                Menu {
                    Button("@naver.com") {
                        newEmailDomain = "@naver.com"
                        let components = newEmail.components(separatedBy: "@")
                        newEmail = components[0] + newEmailDomain
                    }
                    Button("@google.com") {
                        newEmailDomain = "@google.com"
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

                UserInfoEditButton(buttonText: "변경",
                                   isActive: isEditing) {
                    // TODO: 이메일 중복 확인 기능 구현
                    
                    // 변경 가능하면 (중복이 아니고 유효하면)
                    if isValid {
                        // 이메일 변경 api
                        userEmail = newEmail
                    }
                    // 변경 불가능하면
                    // alert
                }
            }

        }
    }
}

struct UserInfoEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoEditView(userInfo: UserInfo(nickname: "길동아밥먹자"))
    }
}
