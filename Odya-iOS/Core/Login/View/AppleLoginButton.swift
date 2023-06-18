//
//  AppleLoginButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/03.
//

import AuthenticationServices
import SwiftUI

/// 애플 로그인 버튼
struct AppleLoginButton: View {
    var body: some View {
        SignInWithAppleButton { request in
            // AppleID 인증 요청
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                debugPrint("DEBUG: 애플 로그인 성공")
                
                switch auth.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let userIdentifier = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let email = appleIDCredential.email
                    // UserDefaults에 저장
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
                    
                    // '최초' 로그인시에만 이름, 이메일 가져오기 가능
                    
                case let passwordCredential as ASPasswordCredential:
                    // Sign in using an existing iCloud Keychain credential.
                    _ = passwordCredential.user
                    _ = passwordCredential.password
                    
                default:
                    break
                }
                
            case .failure(let error):
                debugPrint("DEBUG: 애플 로그인 실패 with error: \(error.localizedDescription)")
            }
        }
        .frame(height: 44)
        .signInWithAppleButtonStyle(.white)
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton()
    }
}
