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
  var isUpdatingProfileImg: Bool = false
  
  // profileImage
  var webpImageManager = WebPImageManager()
  
  // MARK: Init
  
  init() {
    let myData = MyData()
    self.userID = MyData.userID
    self.nickname = myData.nickname
    self.profileData = myData.profile.decodeToProileData()
  }
  
  init(userId: Int, nickname: String, profile: ProfileData) {
    self.userID = userId
    self.nickname = nickname
    self.profileData = profile
  }
  
  // MARK: Fetch Data
  func fetchDataAsync() async {
    guard let idToken = idToken else {
      return
    }
    
    getUserStatistics(idToken: idToken)
  }
  
  // MARK: User Statistics
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
  
  // MARK: Profile Image
  func updateProfileImage(newProfileImg: [ImageData]) async {
    if isUpdatingProfileImg {
      return
    }
    
    isUpdatingProfileImg = true
    
    var newImage: (data: Data, name: String)? = nil
    if !newProfileImg.isEmpty {
      newImage = await webpImageManager.processImages(images: newProfileImg).first
    }
    
    userProvider.requestPublisher(.updateUserProfileImage(profileImg: newImage))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isUpdatingProfileImg = false
        case .failure(let error):
          self.isUpdatingProfileImg = false
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
          // unknown error
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}
