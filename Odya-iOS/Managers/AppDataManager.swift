//
//  AppDataManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/11.
//

import SwiftUI
import FirebaseAuth
import Combine
import CombineMoya
import Moya

class AppDataManager: ObservableObject{
    // moya
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var userProvider = MoyaProvider<UserRouter>(plugins: [plugin])
    
    // token
    @AppStorage("WeITAuthToken") var idToken: String?
    
    
    // MARK: Refresh Token
    
    func refreshToken() async -> Bool {
        return await withCheckedContinuation{ continuation in
            let currentUser = Auth.auth().currentUser
            
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.idToken = nil
                    continuation.resume(returning: false)
                    return
                }
                guard let idToken = idToken else {
                    print("Error: Invalid Token")
                    self.idToken = nil
                    continuation.resume(returning: false)
                    return
                }
                
                // idToken을 이용해 서버 로그인
                self.idToken = idToken
                continuation.resume(returning: true)
            }
        }
    }
    
    // MARK: Init My Data
    
    func initMyData() async throws  {
        return try await withCheckedThrowingContinuation{ continuation in
            guard let idToken = idToken else {
                return
            }
            
            userProvider.request(.getUserInfo(token: idToken)) { result in
                switch result {
                case .success(let response):
                    // debugPrint(response)
                    guard let responseData = try? response.map(UserData.self) else {
                        if let errorData = try? response.map(ErrorData.self) {
                            // print(errorData.message)
                            continuation.resume(throwing: MyError.decodingError(errorData.message))
                            return
                        }
                        continuation.resume(throwing: MyError.decodingError("user data response decoding error"))
                        return
                    }
                    
                    var myData = MyData()
                    myData.userID = responseData.userID ?? -1
                    myData.nickname = responseData.nickname
                    myData.profile = responseData.profileData.encodeToString()
                    
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
