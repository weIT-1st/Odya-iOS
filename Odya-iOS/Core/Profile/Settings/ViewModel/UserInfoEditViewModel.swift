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
  private var subscription = Set<AnyCancellable>()
  
  // user info
  @Published var nickname: String = ""
  @Published var email: String? = nil
  @Published var phoneNumber: String? = nil
  
  // loading flag
  var isFetching: Bool = false
  var isUpdatingNickname: Bool = false
  @Published var isDeletingUser: Bool = false
  
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
}
