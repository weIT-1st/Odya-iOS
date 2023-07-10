//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/25.
//

import SwiftUI
import Alamofire
import Combine

struct SignUpView: View {
    @State var userInfo = UserInfo()
        
    @StateObject private var nicknameValidator = NicknameValidator()

    @State private var validationMessage: String = "닉네임을 입력한 후 중복 확인 버튼을 눌러 주세요!"
    
    var body : some View {
        ZStack {
            Color.background.normal.ignoresSafeArea()
            
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("User Name")
                        .detail1Style()
                    TextField("User Name", text: $userInfo.username)
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Nickname")
                        .detail1Style()
                    HStack {
                        TextField("Nickname", text: $userInfo.nickname)
                            .customTextFieldStyle()
                        Button(action: {
                            print("is valid nickname: \(userInfo.nickname)")
                            nicknameValidator.getNicknameValidation(userInfo.nickname)
                            if nicknameValidator.isChecking {
                                validationMessage = "중복 확인 중..."
                            } else {
                                if let errorMessage = nicknameValidator.errorMessage {
                                    validationMessage = errorMessage
                                } else {
                                    validationMessage = "사용 가능한 닉네임입니다."
                                }
                            }
                        }) {
                            Text("중복 검사")
                                .detail1Style()
                                .padding(19)
                                .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
                                .padding(.bottom, 5)
                        }
                        .disabled(userInfo.nickname == "" || nicknameValidator.isChecking)
                    }
                    Text(validationMessage).detail2Style().foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Email Address")
                        .detail1Style()
                    TextField("Email Address", text: $userInfo.email.toUnwrapped(defaultValue: ""))
                        .customTextFieldStyle()
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Phone Number")
                        .detail1Style()
                    TextField("Phone Number", text: $userInfo.phoneNumber.toUnwrapped(defaultValue: ""))
                        .customTextFieldStyle()
                }
                
                Button(action: {}) {
                    Text("sign up")
                }
                .padding(.vertical, 50)
            }
            .padding(.horizontal, GridLayout.side)

        }
    }
}

struct SighUpView_Previews : PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .detail1Style()
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.gray.opacity(0.6)))
            .padding(.bottom, 5)
    }
}

extension TextField {
    func customTextFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
