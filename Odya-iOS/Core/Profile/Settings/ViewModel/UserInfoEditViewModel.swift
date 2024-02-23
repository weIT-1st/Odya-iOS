//
//  UserInfoEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/30.
//

import SwiftUI
import Moya
import Combine
import CombineMoya
import FirebaseAuth

class UserInfoEditViewModel: ObservableObject {
  // token
  @Published var appDataManager = AppDataManager()
  @AppStorage("WeITAuthToken") var idToken: String?
  @AppStorage("WeITAuthType") var authType: String = ""
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedIn
  
  // Moya
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private lazy var userAuthInfoProvider = MoyaProvider<UserRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // user info
  @Published var nickname: String = ""
  @Published var email: String? = nil
  @Published var phoneNumber: String? = nil
  
  // loading flag
  var isFetching: Bool = false
  var isUpdatingNickname: Bool = false
  @Published var isDeletingUser: Bool = false
  
  @Published var isVerificationInProgress: Bool = false
  @Published var isEmailVerificationInProgress: Bool = false
  
  init() {
    self.fetchMyData()
  }
  
  // MARK: Fetch
  private func fetchMyData() {
    if isFetching {
      return
    }
    
    isFetching = true
    userProvider.requestPublisher(.getUserInfo)
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isFetching = false
        case .failure(let error):
          self.isFetching = false
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          } else {
            print(error)
          }
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserData.self)
          self.nickname = responseData.nickname
          self.email = responseData.email
          self.phoneNumber = responseData.phoneNumber
          
          // 전화번호 형식 맞추기
          if let originalNumber = responseData.phoneNumber {
            let trimmedNumber = originalNumber.hasPrefix("+82") ? "0" + originalNumber.dropFirst(3) : originalNumber
            let formattedNumber = "\(trimmedNumber.prefix(3))-\(trimmedNumber.dropFirst(3).prefix(4))-\(trimmedNumber.suffix(4))"
            self.phoneNumber = formattedNumber
          }
          
        } catch {
          print("UserData decoding error")
          return
        }
      }.store(in: &subscription)
  }
  
  // MARK: Update Nickname
  func updateNickname(_ newNickname: String,
                      completion: @escaping (Bool, String) -> Void) {
    if isUpdatingNickname {
      return
    }
    
    isUpdatingNickname = true
    userProvider.requestPublisher(.updateUserNickname(newNickname: newNickname))
      .sink { apiCompletion in
        self.isUpdatingNickname = false
        switch apiCompletion {
        case .finished:
          completion(true, "변경되었습니다")
          return
        case .failure(let error):
          guard (try? error.response?.map(ErrorData.self)) != nil else {
            completion(false, "오류가 발생하였습니다")
            return
          }
          completion(false, "이미 사용 중인 닉네임입니다")
          return
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: Update PhoneNumber
  func getVerificationCode(newNumber: String,
                           completion: @escaping (Bool) -> Void) {
    // Change language code to korean.
    Auth.auth().languageCode = "kr";
    
    let NumberOnlyStr = "+82 " + newNumber.replacingOccurrences(of: "-", with: "")

    PhoneAuthProvider.provider()
      .verifyPhoneNumber(NumberOnlyStr, uiDelegate: nil) { verificationID, error in
        if let error = error {
          debugPrint(error)
          completion(false)
          return
        }
        
        guard let verificationID = verificationID  else {
          completion(false)
          return
        }
        
        // 인증번호 저장, SMS 앱으로 전환 등 앱이 종료되었을 경우를 위해 디바이스 저장
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        
        self.isVerificationInProgress = true
        completion(true)
      }
  }
  
  func verifyAndUpdatePhoneNumber(verificationCode: String,
                                  completion: @escaping (Bool) -> Void) {
    guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
      completion(false)
      return
    }
    
    let phoneAuthCredential = PhoneAuthProvider.provider().credential(
      withVerificationID: verificationID,
      verificationCode: verificationCode
    )
    
    // 이미 Apple 로그인을 통해 인증된 사용자에게 전화번호 인증 정보를 연결합니다.
    Auth.auth().currentUser?.updatePhoneNumber(phoneAuthCredential) { error in
      if let error = error {
        debugPrint(error)
        completion(false)
        return
      }
      
      Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        // 유효하지 않은 idToken
        if let error = error {
          print("Error: \(error.localizedDescription)")
          completion(false)
          return
        }
        
        // 유효하지 않은 idToken
        guard let idToken = idToken else {
          print("Error: Invalid Token")
          completion(false)
          return
        }
        
        // 성공적으로 전화번호가 인증되고 사용자 계정에 연결되었습니다.
        self.updatePhoneNumberApi(token: idToken) { result in
          self.isVerificationInProgress = false
          completion(result)
          return
        }
      }
    }
  }
  
  private func updatePhoneNumberApi(token: String,
                                    completion: @escaping (Bool) -> Void) {
    userAuthInfoProvider.requestPublisher(.updateUserPhoneNumber(token: token))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
          completion(false)
        }
        
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: Update Email Address
  
  @MainActor
  func verifyEmailAddress(address: String,
                          completion: @escaping (Bool, String) -> Void) {
    if let user = Auth.auth().currentUser {
      user.updateEmail(to: address) { error in
        if let error = error as NSError? {
          if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
            completion(false, "재로그인 후 다시 시도해주세요.")
            return
          }
          
          if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
            completion(false, "이미 사용 중인 이메일 주소입니다.")
            return
          }
          
          print(error)
          completion(false, "인증 이메일 전송을 실패하였습니다. 다시 시도해주세요.")
          return
        }
        
        user.sendEmailVerification { error in
          if let error = error {
            print(error)
            completion(false, "인증 이메일 전송을 실패하였습니다. 다시 시도해주세요.")
            return
          }
          
          self.isEmailVerificationInProgress = true
          completion(true, "인증 이메일이 성공적으로 전송되었습니다. 이메일을 확인해주세요.")
          return
        }
      }
    } else {
      completion(false, "재로그인 후 다시 시도해주세요.")
      return
    }
  }
  
  func verifyAndUpdateEmailAddress(completion: @escaping (Bool, String) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(false, "이메일 인증 중 오류가 발생했습니다. 다시 시도해주세요")
      self.isEmailVerificationInProgress = false
      return
    }
    
    user.reload() { (error) in
      if let error = error {
        print("Error reloading user: \(error.localizedDescription)")
        completion(false, "이메일 인증 중 오류가 발생했습니다. 다시 시도해주세요")
        self.isEmailVerificationInProgress = false
        return
      }
      
      if !user.isEmailVerified {
        // 이메일 인증이 아직 완료되지 않음.
        print("Email not verified yet.")
        completion(false, "이메일 주소가 아직 인증되지 않았습니다. 이메일을 확인해주세요.")
        return
      }
      
      user.getIDTokenForcingRefresh(true) { idToken, error in
        // 유효하지 않은 idToken
        if let error = error {
          print("Error: \(error.localizedDescription)")
          completion(false, "이메일 인증 중 오류가 발생했습니다. 다시 시도해주세요")
          self.isEmailVerificationInProgress = false
          return
        }
        
        // 유효하지 않은 idToken
        guard let idToken = idToken else {
          print("Error: Invalid Token")
          completion(false, "이메일 인증 중 오류가 발생했습니다. 다시 시도해주세요")
          self.isEmailVerificationInProgress = false
          return
        }
        
        // 이메일 인증이 완료되었음. 서버에 API 요청을 보냄.
        self.updateEmailAddressApi(token: idToken) { success in
          if success {
            completion(true, "이메일 주소가 인증되었습니다.")
            self.isEmailVerificationInProgress = false
          } else {
            completion(false, "이메일 주소가 아직 인증되지 않았습니다. 이메일을 확인해주세요.")
          }
        }
      }
    }
  }
  
  private func updateEmailAddressApi(token: String,
                                    completion: @escaping (Bool) -> Void) {
    userAuthInfoProvider.requestPublisher(.updateUserEmailAddress(token: token))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
          completion(false)
        }
        
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: Logout
  @MainActor
  func logout() {
    appDataManager.deleteMyData()
    appDataManager.deleteLocalDB()
    switch authType {
    case "kakao":
      KakaoAuthViewModel().kakaoLogout()
    case "apple":
      AppleAuthViewModel().AppleLogout()
    default:
      idToken = nil
      authType = ""
    }
  }
  
  // MARK: Delete User
  func deleteUser() {
    if isDeletingUser {
      return
    }
    
    isDeletingUser = true
    userProvider.requestPublisher(.deleteUser)
      .sink { completion in
        self.isDeletingUser = false
        switch completion {
        case .finished:
          self.appDataManager.deleteMyData()
          self.appDataManager.deleteLocalDB()
          self.idToken = nil
          self.authType = ""
          self.authState = .loggedOut
          
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
          // unknown error
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("ERROR: In User Edit VM with \(errorData.message)")
    } else {  // unknown error
      print("ERROR: \(error.localizedDescription)")
    }
  }
}
