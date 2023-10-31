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
//    case tokenError
}

class ProfileViewModel: ObservableObject {
    
    // Moya
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var userProvider = MoyaProvider<UserRouter>(plugins: [plugin])
    private lazy var followProvider = MoyaProvider<FollowRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    
    // user Data
    @Published var appDataManager = AppDataManager()
    
    @AppStorage("WeITAuthToken") var idToken: String?
    
    @Published var userID: Int
    @Published var nickname: String
    @Published var profileData: ProfileData
    
    @Published var followCount = FollowCount()
    
    //  flag
    var isFetchingFollowCount: Bool = false
    
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
        
        do {
            try await getFollowCount(idToken: idToken)
        } catch {
            switch error {
            case MyError.apiError(let error):
                if error.code == -11000 {
                    print("Invalid Token")
                    if await appDataManager.refreshToken() {
                        await self.fetchDataAsync()
                    }
                } else {
                    print("Fetching failed with error:", error)
                }

            default:
                print("Fetching failed with error:", error)
            }
        }
    }
    
    
    
    private func getFollowCount(idToken: String) async throws {
        if isFetchingFollowCount {
            return
        }
        
        isFetchingFollowCount = true
        
        return try await withCheckedThrowingContinuation { continuation in
            followProvider.requestPublisher(.count(token: idToken, userID: self.userID))
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.isFetchingFollowCount = false
                    case .failure(let error):
                        self.isFetchingFollowCount = false
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { response in
                    if let responseData = try? response.map(FollowCount.self) {
                        self.followCount = responseData
                        return
                    }
                    
                    guard let errorData = try? response.map(ErrorData.self) else {
                        continuation.resume(throwing: MyError.decodingError("follow count response decoding error"))
                        return
                    }
                    continuation.resume(throwing: MyError.apiError(errorData))
                }.store(in: &subscription)
        }   
    }
}
