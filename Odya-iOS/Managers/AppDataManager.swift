//
//  AppDataManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/11.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class AppDataManager: ObservableObject {
  // moya
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // token
  @AppStorage("WeITAuthToken") var idToken: String?
  
  // MARK: Refresh Token
  
  func refreshToken(completion: @escaping (Bool) -> Void) {
    let currentUser = Auth.auth().currentUser
    
    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
        self.idToken = nil
        completion(false)
        return
      }
      guard let idToken = idToken else {
        print("Error: Invalid Token")
        self.idToken = nil
        completion(false)
        return
      }
      
      // idToken을 이용해 서버 로그인
      self.idToken = idToken
      completion(true)
    }
  }
  
  
  
  // MARK: Init My Data
  
  func initMyData(completion: @escaping (Bool) -> Void) {
    
    guard idToken != nil else {
      return
    }
    
    userProvider.requestPublisher(.getUserInfo)
      .filterSuccessfulStatusCodes()
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          completion(true)
          break
        case .failure(let error):
          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            // unknown error
            return
          }
          
          if apiError.code == -11000 {
            self.refreshToken { success in
              // token error handling
              if success {
                self.initMyData() { _ in }
                return
              }
              
            }
            
          }
          // other api error handling
          completion(false)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserData.self)
          var myData = MyData()
          MyData.userID = responseData.userID ?? -1
          myData.nickname = responseData.nickname
          myData.profile = responseData.profileData.encodeToString()
        } catch {
          // decoding error handling
        }
        
      }.store(in: &subscription)
    
  }
  
  func deleteMyData() {
    MyData.userID = -1
    var myData = MyData()
    myData.nickname = ""
    myData.profile = ""
  }
}
