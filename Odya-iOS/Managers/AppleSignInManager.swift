//
//  AppleSignInManager.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import AuthenticationServices
import UIKit
import SwiftUI

final class AppleSignInManager {
    static let shared = AppleSignInManager()
    
    private init() { }
    
    // MARK: - Helpers
    
    /// 애플 로그인 상태확인
    func checkIfLoginWithApple() async -> Bool {
        let provider = ASAuthorizationAppleIDProvider()
        do {
            let state = try await provider.credentialState(forUserID: AppleUserData.userIdentifier)
            switch state {
            case .authorized:
                // 유효한 Apple ID Credential (인증성공)
                debugPrint("DEBUG: Apple ID is authorized")
                return true
            case .revoked:
                // 인증만료
                debugPrint("DEBUG: Apple ID is revoked")
            case .notFound:
                debugPrint("DEBUG: Apple ID is not found")
            default:
                break
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        return false
    }
    
}
