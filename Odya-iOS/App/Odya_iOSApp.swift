//
//  Odya_iOSApp.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI
import AuthenticationServices

@main
struct Odya_iOSApp: App {
    
    init() {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: AppleUserData.userIdentifier) { credentialState, error in
            switch credentialState {
            case .authorized:
                // 유효한 Apple ID Credential
                print("DEBUG: Apple ID is authorized")
                print("""
                DEBUG: 애플 로그인 정보
                    userIdentifier: \(AppleUserData.userIdentifier)
                    familyName: \(AppleUserData.familyName)
                    givenName: \(AppleUserData.givenName)
                    email: \(AppleUserData.email)
                """)
            case .revoked:
                print("DEBUG: Apple ID is revoked")
            case .notFound:
                print("DEBUG: Apple ID is not found")

            default:
                break
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
//            LoginView()
            AppleLoginButton()
        }
    }
}
