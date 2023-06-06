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
    // TODO: - 생성자 내부의 애플로그인 상태 확인 코드를 Appdelegate의 didFinishLaunchingWithOptions, applicationDidBecomeActive에서 모두 실행하도록 변경
    init() {
        /// 애플 로그인 상태확인
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: AppleUserData.userIdentifier) { credentialState, error in
            switch credentialState {
            case .authorized:
                // 유효한 Apple ID Credential (인증성공)
                debugPrint("DEBUG: Apple ID is authorized")
            case .revoked:
                // 인증만료
                debugPrint("DEBUG: Apple ID is revoked")
            case .notFound:
                debugPrint("DEBUG: Apple ID is not found")
            default:
                break
            }
        }
    }
    
    // TODO: - 로그인 로직 수정
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
