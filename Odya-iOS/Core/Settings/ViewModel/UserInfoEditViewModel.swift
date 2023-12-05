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
  
  // loading flag
  var isDeletingUser: Bool = false
  
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
  
  func deleteUser() {
    if isDeletingUser {
      return
    }
    
    isDeletingUser = true
    appDataManager.deleteMyData()
    userProvider.requestPublisher(.deleteUser)
      .sink { completion in
        self.isDeletingUser = false
        switch completion {
        case .finished:
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
