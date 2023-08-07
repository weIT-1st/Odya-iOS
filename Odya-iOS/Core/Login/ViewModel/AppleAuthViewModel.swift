//
//  AppleAuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/22.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices

class AppleAuthViewModel: ObservableObject {
    
    @Published var AuthApi = AuthViewModel()
    
    @Published var isUnauthorized: Bool = false
    
    @Published var userInfo = UserInfo()
    
    /// 토큰
    @AppStorage("WeITAuthToken") var idToken: String?
    
    var currentNonce: String? = nil
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        
        /// 로그인 요청마다 임의의 문자열인 'nonce'가 생성되며, 이 nonce는 앱의 인증 요청에 대한 응답으로 ID 토큰이 명시적으로 부여되었는지 확인하는 데 사용됩니다. 재전송 공격을 방지하려면 이 단계가 필요합니다.
        /// 로그인 요청과 함께 nonce의 SHA256 해시를 전송하면 Apple은 이에 대한 응답으로 원래의 값을 전달합니다. Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    /// 애플 소셜 로그인 성공 시 실행되는 handler
    /// 애플 소셜 로그인 -> 파이어베이스 로그인/연동 -> 파이어베이서 토큰을 이용해 서버 로그인
    func handleSignInWithAppleCompletion(_ appleSigninResult: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = appleSigninResult {
            debugPrint(failure.localizedDescription)
        } else if case .success(let success) = appleSigninResult {
            // print("애플 소셜 로그인 성공")
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                
                // firebase login
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Error in AppleAuthViewModel handleSignInWithAppleCompletion(): Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Error in AppleAuthViewModel handleSignInWithAppleCompletion(): Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                guard let nonce = currentNonce else {
                    fatalError("Error in AppleAuthViewModel handleSignInWithAppleCompletion(): Invalid state: a login callback was received, but no login request was sent.")
                    return
                }
                
                let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                Auth.auth().signIn(with: firebaseCredential) { firebaseSignInResult, error in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    
                    // print("firebase 로그인 완료")
                    
                    // idToken 유효성 확인
                    let currentUser = Auth.auth().currentUser
                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        if let error = error {
                            print("Error in AppleAuthViewModel handleSignInWithAppleCompletion(): \(error.localizedDescription)")
                            return
                        }
                        
                        // idToken을 이용해 서버 로그인
                        if let idToken = idToken {
                            // user info
                            // let userIdentifier = appleIDCredential.user
                            self.userInfo.idToken = idToken
                            if let fullName = appleIDCredential.fullName,
                               let givenName = fullName.givenName,
                               let familyname = fullName.familyName {
                                self.userInfo.username = givenName + familyname
                            }
                            if let email = appleIDCredential.email {
                                self.userInfo.email = email
                            }
                            self.doServerLogin(idToken: idToken)
                        } else {
                            print("Error in AppleAuthViewModel handleSignInWithAppleCompletion(): Invalid Token")
                            return
                        }
                    }
                }
            }
        }
    }
    
    /// 서버 로그인 api 호출
    private func doServerLogin(idToken: String) {
        AuthApi.appleLogin(idToken: idToken) { apiResult in
            switch apiResult {
            case .success:
                print("apple login complete")
                self.idToken = idToken
            case .unauthorized:
                print("Error in AppleAuthViewModel doServerLogin(): valid token but required to register")
                // TODO: SignUpView 연결하기
                self.isUnauthorized = true
            case .error(let errorMessage):
                print("Error in AppleAuthViewModel doServerLogin(): \(errorMessage)")
                
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

