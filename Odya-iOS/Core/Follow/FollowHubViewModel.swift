//
//  FollowListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import Foundation
import Combine
import CombineMoya
import Moya

class FollowHubViewModel: ObservableObject {
    
    // MARK: Parameters
    
    // api provider
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var followProvider = MoyaProvider<FollowRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    
    var fetchMoreSubject = PassthroughSubject<(), Never>()
    var suggestMoreSubject = PassthroughSubject<(), Never>()
    
    // user info required for API calls
    let idToken: String
    let userID: Int
    
    // follow
    let usersFetchSize: Int = 20
    let usersSuggestionSize: Int = 10
    let usersSortingType: FollowSortingType = .latest
    
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var currentFollowType: FollowType
    @Published var followCount: FollowCount
    
    // fetch following/follwer users
    var followingPage: Int = 0
    var hasNextFollowingPage: Bool = true
    @Published var followingUsers: [FollowUserData] = []
    
    var followerPage: Int = 0
    var hasNextFollowerPage: Bool = true
    @Published var followerUsers: [FollowUserData] = []

    // suggest user
    var lastIdOfSuggestion: Int? = nil
    var hasNextSuggestion: Bool = true
    @Published var suggestedUsers: [FollowUserData] = []
    
    // MARK: Init
    
    init(token: String, userID: Int, followCount: FollowCount) {
        self.idToken = token
        self.userID = userID
        self.followCount = followCount
        self.currentFollowType = .following
        
        self.fetchFollowingUsers()
        self.fetchFollowerUsers()
        self.suggestUsers()
        
        fetchMoreSubject.sink { [weak self] _ in
            guard let self = self else { return }
            if !self.isLoading {
                switch currentFollowType {
                case .following:
                    self.fetchFollowingUsers()
                case .follower:
                    self.fetchFollowingUsers()
                }
            }
        }.store(in: &subscription)
        
        suggestMoreSubject.sink { [weak self] _ in
            guard let self = self else { return }
            if !self.isLoading {
                self.suggestUsers()
            }
        }.store(in: &subscription)
    }
    
    // MARK: follow / unfollow
    func createFollow(_ followingID: Int) {
        followProvider.requestPublisher(.create(token: self.idToken, followingID: followingID))
            .sink { completion in
                switch completion {
                case .finished:
                    print("create new follow \(followingID)")
                case .failure(let error):
                    if let errorData = try? error.response?.map(ErrorData.self) {
                        print(errorData.message)
                    }
                }
            } receiveValue: { _ in }
            .store(in: &subscription)
    }
    
    func deleteFollow(_ followingID: Int) {
        followProvider.requestPublisher(.delete(token: self.idToken, followingID: followingID))
            .sink { completion in
                switch completion {
                case .finished:
                    print("delete follow \(followingID)")
                case .failure(let error):
                    if let errorData = try? error.response?.map(ErrorData.self) {
                        print(errorData.message)
                    }
                }
            } receiveValue: { _ in }
            .store(in: &subscription)
    }
    
    // MARK: Fetch Follow Users
    
    func initFetchData() {
        isRefreshing = true
        
        self.followingPage = 0;
        self.hasNextFollowingPage = true
        self.followingUsers = []
        
        self.followerPage = 0;
        self.hasNextFollowingPage = true
        self.followerUsers = []
    }
    
    func fetchFollowingUsers() {
        if self.hasNextFollowingPage == false {
            print("all following users are fetched")
            return
        }
        
        self.isLoading = true
        
        followProvider.requestPublisher(
            .getFollowing(token: self.idToken, userID: self.userID, page: self.followingPage, size: self.usersFetchSize, sortType: self.usersSortingType))
        .sink { completion in
            self.isLoading = false
            self.isRefreshing = false
            switch completion {
            case .finished:
                self.followingPage += 1
                 print("fetch \(self.followingPage)th following users: now \(self.followingUsers.count) users are fetched")
            case .failure(let error):
                if let errorData = try? error.response?.map(ErrorData.self) {
                    print(errorData.message)
                }
            }
        } receiveValue: { response in
            guard let responseData = try? response.map(FollowUserListResponse.self) else {
                print("Error: following users response decoding error")
                return
            }
            
            self.hasNextFollowingPage = responseData.hasNext
            self.followingUsers += responseData.content
        }
        .store(in: &subscription)
    }
    
    func fetchFollowerUsers() {
        if self.hasNextFollowerPage == false {
            print("all follower users are fetched")
            return
        }
        
        self.isLoading = true
        
        followProvider.requestPublisher(
            .getFollower(token: self.idToken, userID: self.userID, page: self.followerPage, size: self.usersFetchSize, sortType: self.usersSortingType))
        .sink { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                self.followerPage += 1
                // print("fetch \(self.followerPage)th following users: now \(self.followerUsers.count) users are fetched")
            case .failure(let error):
                if let errorData = try? error.response?.map(ErrorData.self) {
                    print(errorData.message)
                }
            }
        } receiveValue: { response in
            guard let responseData = try? response.map(FollowUserListResponse.self) else {
                print("Error: following users response decoding error")
                return
            }
            
            self.hasNextFollowerPage = responseData.hasNext
            self.followerUsers += responseData.content
        }
        .store(in: &subscription)
    }
    
    // MARK: Suggest User
    
    func suggestUsers() {
        if self.hasNextSuggestion == false {
            print("no more suggestion")
            return
        }
        
        self.isLoading = true
        
        followProvider.requestPublisher(
            .suggestUser(token: self.idToken, size: self.usersSuggestionSize, lastID: self.lastIdOfSuggestion))
        .sink { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                self.lastIdOfSuggestion = nil
                if let lastUser = self.suggestedUsers.last {
                    self.lastIdOfSuggestion = lastUser.userId
                }
                 print("suggest total \(self.suggestedUsers.count) users")
            case .failure(let error):
                if let errorData = try? error.response?.map(ErrorData.self) {
                    print(errorData.message)
                }
            }
        } receiveValue: { response in
            guard let responseData = try? response.map(FollowUserListResponse.self) else {
                print("Error: following users response decoding error")
                return
            }
            
            self.hasNextSuggestion = responseData.hasNext
            self.suggestedUsers += responseData.content
        }
        .store(in: &subscription)
    }
    
}
