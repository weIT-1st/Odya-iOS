//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/25.
//

import SwiftUI
import Alamofire
import Combine


enum SocialAccountType {
    case kakao(String)
    case apple(String)
}

struct SignUpView: View {
    @State var userInfo = UserInfo()
    @StateObject var authVM = AuthViewModel()
    private var isKakaoAccount: Bool
    
    init(socialType: SocialAccountType, nickname: String, email: String?, phoneNumber: String?, gender: String?) {
        switch socialType {
        case .kakao(let username):
            self.isKakaoAccount = true
            self.userInfo.username = username
        case .apple(let idToken):
            self.isKakaoAccount = false
            self.userInfo.idToken = idToken
        }
        self.userInfo.nickname = nickname
        self.userInfo.email = email
        self.userInfo.phoneNumber = phoneNumber
        self.userInfo.gender = gender ?? ""
    }

    var body : some View {
        ZStack {
            Color.background.normal.ignoresSafeArea()
            
            VStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Nickname")
                        .detail1Style()
                    HStack {
                        TextField("Nickname", text: $userInfo.nickname)
                            .customTextFieldStyle()
                    }
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
                
                Button(action: {
                    if isKakaoAccount == true {
                        authVM.kakaoRegister(username: userInfo.username, email: userInfo.email, phoneNumber: userInfo.phoneNumber, nickname: userInfo.nickname, gender: "M", birthday: [1999, 10, 10]) { isSuccess, errorMessage in
                            print("SignUp Button")
                            if isSuccess == true {
                                print("success")
                                // TODO: kakao server login 다시 호출 & 파이어베이스 연동
                            } else if let message = errorMessage {
                                print(message)
                            } else {
                                print("unknown error")
                            }
                        }
                    } else {
                        authVM.appleRegister(idToken: userInfo.idToken, email: userInfo.email, phoneNumber: userInfo.phoneNumber, nickname: userInfo.nickname, gender: "M", birthday: [1999, 10, 10]) { isSuccess, errorMessage in
                            print("SignUp Button")
                            if isSuccess == true {
                                print("success")
                            } else if let message = errorMessage {
                                print(message)
                            } else {
                                print("unknown error")
                            }
                        }
                    }
                }) {
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
        var userInfo = UserInfo()
        var kakaoAccountType = SocialAccountType.kakao("KAKAO_1234")
        // var appleAccountType = SocialAccountType.kakao("testIdToken")
        SignUpView(socialType: kakaoAccountType, nickname: "testNickname", email: nil, phoneNumber: nil, gender: nil)
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
