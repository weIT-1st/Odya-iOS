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
    case decodingError(String)
    case tokenError
}

class ProfileViewModel: ObservableObject {
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var userProvider = MoyaProvider<UserRouter>(plugins: [plugin])
    private lazy var followProvider = MoyaProvider<FollowRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    
    @Published var idTokenManager = IdTokenManager()
    @AppStorage("WeITAuthToken") var idToken: String?
    
    @Published var isFetching: Bool = false
    
    @Published var userID: Int? = nil
    @Published var nickname: String = ""
    @Published var email: String? = nil
    @Published var phoneNumber: String? = nil
    @Published var gender: Gender = .none
    @Published var birthday: Date? = nil
    @Published var profileData: ProfileData = ProfileData(profileUrl: "https://objectstorage.ap-chuncheon-1.oraclecloud.com/p/0wFrAwWxeRqeXG2gq38hIP4o0RpirOq9N0bwgctw51KZE43OtSraBRE4qGBL97P7/n/axivk99fjind/b/Odya-stable/o/default_profile.png", profileColor: nil)
    @Published var followCount = FollowCount()
    
    func fetchDataAsync() async {
        guard let idToken = idToken else {
            return
        }
        
        isFetching = true
        
        do {
            try await getUserInfo(of: idToken)
            
            // getUserInfo()를 통해 유저 정보를 가져온 후 순차적으로 진행됨
            async let followCountResponse = getFollowCount(idToken: idToken)
            self.followCount = try await followCountResponse
            
            isFetching = false
        } catch {
            switch error {
            case MyError.tokenError:
                print("token error")
                if await idTokenManager.refreshToken() {
                    await self.fetchDataAsync()
                }
                
            default:
                print("Fetching failed with error:", error)
            }
        }
    }
    
    private func getUserInfo(of idToken: String) async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            userProvider.request(.getUserInfo(token: idToken)) { result in
                switch result {
                case .success(let response):
                    // debugPrint(response)
                    guard let responseData = try? response.map(UserData.self) else {
                        if let errorData = try? response.map(ErrorData.self) {
                            // print(errorData.message)
                            if errorData.code == -11000 {
                                continuation.resume(throwing: MyError.tokenError)
                                return
                            }
                        }
                        
                        continuation.resume(throwing: MyError.decodingError("user data response decoding error"))
                        return
                    }
                    
                    self.userID = responseData.userID
                    self.nickname = responseData.nickname
                    self.email = responseData.email
                    self.phoneNumber = responseData.phoneNumber
                    self.gender = {
                        switch responseData.gender {
                        case "M": return .male
                        case "F": return .female
                        default: return .none
                        }
                    }()
                    self.birthday = responseData.birthday.toDate()
                    self.profileData = responseData.profileData
                    continuation.resume()
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func getFollowCount(idToken: String) async throws -> FollowCount {
        return try await withCheckedThrowingContinuation { continuation in
            guard let userID = self.userID else {
                continuation.resume(throwing: MyError.decodingError("invalid userID"))
                return
            }
            
            followProvider.request(.count(token: idToken, userID: userID)) { result in
                switch result {
                case .success(let response):
                    guard let responseData = try? response.map(FollowCount.self) else {
                        continuation.resume(throwing: MyError.decodingError("follow count response decoding error"))
                        return
                    }
                    continuation.resume(returning: responseData)
                case .failure(let error):
                    if let errorData = try? error.response?.map(ErrorData.self) {
                        print(errorData.message)
                    }
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
