//
//  AppleAuthViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/22.
//

import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI

class AppleAuthViewModel: ObservableObject {

  // MARK: Properties

  /// 앱 내에서 사용할 idToken (= firebase token)
  @AppStorage("WeITAuthToken") var idToken: String?
  @AppStorage("WeITAuthType") var authType: String = ""

  @Published var AuthApi = AuthViewModel()

  /// 로그인한 회원이 등록되어 있는지 여부, 등록되어 있지 않으면 true
  @Published var isUnauthorized: Bool = false

  /// 로그인한 회원 정보 - 회원가입 시 사용됨
  @Published var userInfo = UserInfo()

  /// Nonce handling
  var currentNonce: String? = nil

  // MARK: Sign In With Apple Handling

  /// 애플 소셜 로그인 요청 시 실행되는 handler
  func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName, .email]

    /* 로그인 요청마다 임의의 문자열인 'nonce'가 생성되며, 이 nonce는 앱의 인증 요청에 대한 응답으로 ID 토큰이 명시적으로 부여되었는지 확인하는 데 사용됩니다.
         * 재전송 공격을 방지하려면 이 단계가 필요합니다.
         * 로그인 요청과 함께 nonce의 SHA256 해시를 전송하면 Apple은 이에 대한 응답으로 원래의 값을 전달합니다.
         * Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
         */
    let nonce = randomNonceString()
    currentNonce = nonce
    request.nonce = sha256(nonce)
  }

  /// 애플 소셜 로그인 성공 시 실행되는 handler
  /// 애플 소셜 로그인 -> 파이어베이스 로그인/연동 -> 파이어베이서 토큰을 이용해 서버 로그인
  func handleSignInWithAppleCompletion(_ appleSignInResult: Result<ASAuthorization, Error>) {
    idToken = nil
    // apple social login success
    guard case .success(let success) = appleSignInResult,
      let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential
    else {
      if case .failure(let failure) = appleSignInResult {
        debugPrint(failure.localizedDescription)
      }
      return
    }

    // firebase login
    guard let appleIDToken = appleIDCredential.identityToken,
      let idTokenString = String(data: appleIDToken, encoding: .utf8)
    else {
      print("Error: Unable to fetch identity token.")
      return
    }

    guard let nonce = currentNonce else {
      fatalError(
        "Error: Invalid state - a login callback was received, but no login request was sent.")
    }

    let firebaseCredential = OAuthProvider.credential(
      withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

    Auth.auth().signIn(with: firebaseCredential) { firebaseSignInResult, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
        return
      }

      // firebase login success
      let currentUser = Auth.auth().currentUser
      currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        if let error = error {
          print("Error: \(error.localizedDescription)")
          return
        }

        // sever login
        if let idToken = idToken {
          self.userInfo.idToken = idToken
          if let fullName = appleIDCredential.fullName,
            let givenName = fullName.givenName,
            let familyName = fullName.familyName
          {
            self.userInfo.username = givenName + familyName
          }
          if let email = appleIDCredential.email {
            self.userInfo.email = email
          }
          self.doServerLogin(idToken: idToken)
        } else {
          print("Error: Invalid Token")
        }
      }
    }
  }

  // MARK: Server Login

  /// 서버 로그인 api 호출
  /// 서버 로그인 성공 시 받아온 토큰 저장
  /// 등록되지 않은 회원일 경우 회원가입 페이지로 이동
  private func doServerLogin(idToken: String) {
    AuthApi.appleLogin(idToken: idToken) { apiResult in
      switch apiResult {
      case .success:
        // print("로그인 성공")
        self.idToken = idToken
        self.authType = "apple"
      case .unauthorized:
        print("Error: Valid token but required to register")
        self.isUnauthorized = true
      case .error(let errorMessage):
        print("Error: \(errorMessage)")
      }
    }
  }

  // MARK: Logout
  func AppleLogout() {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      idToken = nil
      authType = ""
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
  }

  // MARK: Helper Functions

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
