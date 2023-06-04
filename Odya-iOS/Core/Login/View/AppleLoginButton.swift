//
//  AppleLoginButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/03.
//

import AuthenticationServices
import SwiftUI

/// 애플 로그인 버튼
/// - 현재 버튼 디자인: 기본적으로 제공되는 디자인(서체, 색상, Corner radius 모두 기본)
struct AppleLoginButton: View {
    var body: some View {
        SignInWithAppleButton { request in
            // AppleID 인증을 요청
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                print("DEBUG: 애플 로그인 성공")
                
                switch auth.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let userIdentifier = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let email = appleIDCredential.email
                    
                    AppleUserData.userIdentifier = userIdentifier
                    
                    if let familyName = fullName?.familyName {
                        AppleUserData.familyName = familyName
                    }
                    
                    if let givenName = fullName?.givenName {
                        AppleUserData.givenName = givenName
                    }
                    
                    if let email = email {
                        AppleUserData.email = email
                    }
                    
                    print("""
                    DEBUG: 로그인 정보
                        userIdentifier: \(AppleUserData.userIdentifier)
                        familyName: \(AppleUserData.familyName))
                        givenName: \(AppleUserData.givenName))
                        email: \(AppleUserData.email))
                    """)
                    // 한번 가입한 후에는 애플아이디 사용중단해도 revoked 되는거라 이름, 이메일안뜸
                    
                case let passwordCredential as ASPasswordCredential:
                    // Sign in using an existing iCloud Keychain credential.
                    let username = passwordCredential.user
                    let password = passwordCredential.password
                    
                default:
                    break
                }
                
                
            case .failure(let error):
                print("DEBUG: 애플 로그인 실패 with error: \(error.localizedDescription)")
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton()
    }
}
