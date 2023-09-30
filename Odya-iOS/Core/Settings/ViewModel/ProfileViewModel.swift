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
}

class ProfileViewModel: ObservableObject {
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var userProvider = MoyaProvider<UserRouter>(plugins: [plugin])
    private lazy var followProvider = MoyaProvider<FollowRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    
    let idToken: String
    
    @Published var userID: Int? = nil
    @Published var nickname: String = ""
    @Published var email: String? = nil
    @Published var phoneNumber: String? = nil
    @Published var gender: Gender = .none
    @Published var birthday: Date? = nil
    @Published var profileData: ProfileData = ProfileData(profileUrl: "https://objectstorage.ap-chuncheon-1.oraclecloud.com/p/0wFrAwWxeRqeXG2gq38hIP4o0RpirOq9N0bwgctw51KZE43OtSraBRE4qGBL97P7/n/axivk99fjind/b/Odya-stable/o/default_profile.png", profileColor: nil)
    @Published var followCount = FollowCount()
    
    init(idToken: String) {
        self.idToken = idToken
    }
    
//    @MainActor
    func fetchDataAsync() async {
        do {
            try await getUserInfo()
            
            // After getUserInfoAsync(), other requests can be made concurrently.
            async let followCountResponse = getFollowCount()
            self.followCount = try await followCountResponse
        } catch {
            print("Fetching failed with error:", error)
        }
    }
    
    func getUserInfo() async throws {
        return try await withCheckedThrowingContinuation{ continuation in
            userProvider.request(.getUserInfo(token: self.idToken)) { result in
                switch result {
                case .success(let response):
                    debugPrint(response)
                    guard let responseData = try? response.map(UserData.self) else {
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
    
    func getFollowCount() async throws -> FollowCount {
        return try await withCheckedThrowingContinuation { continuation in
            guard let userID = self.userID else {
                continuation.resume(throwing: MyError.decodingError("invalid userID"))
                return
            }
            
            followProvider.request(.count(token: self.idToken, userID: userID)) { result in
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
