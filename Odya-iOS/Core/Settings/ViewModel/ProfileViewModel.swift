//
//  ProfileViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya
import Moya

enum MyError: Error {
    case unknown(String)
    case decodingError(String)
    case apiError(ErrorData)
    case tokenError
}

class ProfileViewModel: ObservableObject {
  // token
  @Published var appDataManager = AppDataManager()
  @AppStorage("WeITAuthToken") var idToken: String?
  
  // Moya
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // user data
  @Published var userID: Int
  @Published var nickname: String
  @Published var profileData: ProfileData
  
  @Published var statistics = UserStatistics()
  
  //  flag
  var isFetchingStatistics: Bool = false
  
  init() {
    let myData = MyData()
    self.userID = MyData.userID
    self.nickname = myData.nickname
    self.profileData = myData.profile.decodeToProileData()
  }
  
  func fetchDataAsync() async {
    guard let idToken = idToken else {
      return
    }
    
    getUserStatistics(idToken: idToken)
  }
  
  
  
  private func getUserStatistics(idToken: String) {
    if isFetchingStatistics {
      return
    }
    
    isFetchingStatistics = true
    
    userProvider.requestPublisher(.getUserStatistics(userId: self.userID))
      .sink { completion in
        switch completion {
        case .finished:
          self.isFetchingStatistics = false
        case .failure(let error):
          self.isFetchingStatistics = false
          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            // unknown error
            return
          }
          
          if apiError.code == -11000 {
            self.appDataManager.refreshToken { success in
              // token error handling
              if success {
                self.getUserStatistics(idToken: idToken)
                return
              }
            }
          }
          // other api error handling
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserStatistics.self)
          self.statistics = responseData
        } catch {
          return
        }
      }.store(in: &subscription)
  }
}
