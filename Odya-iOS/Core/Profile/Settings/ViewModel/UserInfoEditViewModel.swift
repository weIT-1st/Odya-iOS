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
  
  func verifyAndUpdatePhoneNumber(newNumber: String,
                                  verificationCode: String,
                                  completion: @escaping (Bool) -> Void) {
    guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
      completion(false)
      return
    }
    
    let credential = PhoneAuthProvider.provider().credential(
      withVerificationID: verificationID,
      verificationCode: verificationCode
    )
    
//    Auth.auth().signIn(with: credential) { authData, error in
//      if let error = error {
//        print(error)
//        completion(false)
//        return
//      }
      
      // 성공시 CurrentUser IDTokenRefresh처리
      let currentUser = Auth.auth().currentUser
      currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        if let error = error {
          print(error)
          completion(false)
          return
        }
        
        guard let token = idToken else {
          completion(false)
          return
        }
        
        self.updatePhoneNumberApi(token: token) { success in
          if success {
            self.phoneNumber = newNumber
            self.isVerificationInProgress = false
            completion(true)
          } else {
            self.isVerificationInProgress = false
            completion(false)
          }
        }
        
      }
//    }
    
    
  }
  
  private func updatePhoneNumberApi(token: String,
                                    completion: @escaping (Bool) -> Void) {
//    self.tokenToEditInfo = token
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

  
  // MARK: Logout
  @MainActor
  func logout() {
    appDataManager.deleteMyData()
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
