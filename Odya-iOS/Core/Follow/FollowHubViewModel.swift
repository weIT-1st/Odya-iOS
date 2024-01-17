//
//  FollowListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import SwiftUI
import Combine
import CombineMoya
import Foundation
import Moya

class FollowHubViewModel: ObservableObject {
  
  // MARK: Parameters
  
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var followProvider = MoyaProvider<FollowRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // infinite scroll
  var fetchMoreSubject = PassthroughSubject<(Int), Never>()
  var suggestMoreSubject = PassthroughSubject<(), Never>()
  
  // user info required for API calls
  //  var userID: Int
  @Published var currentFollowType: FollowType
  
  // fetch following/follwer users
  @Published var isLoading: Bool = false
  @Published var isRefreshing: Bool = false
  
  var followingPage: Int = 0
  var hasNextFollowingPage: Bool = true
  @Published var followingUsers: [FollowUserData] = []
  
  var followerPage: Int = 0
  var hasNextFollowerPage: Bool = true
  @Published var followerUsers: [FollowUserData] = []
  
  // suggest user
  @Published var isLoadingSuggestion: Bool = false
  
  var lastIdOfSuggestion: Int? = nil
  var hasNextSuggestion: Bool = true
  @Published var suggestedUsers: [FollowUserData] = []
  
  // search by name
  @Published var isLoadingSearchResult: Bool = false
  @Published var followingSearchResult: [FollowUserData] = []
  @Published var followerSearchResult: [FollowUserData] = []
  
  /* 닉네임 검색 api 사용 시 필요
   var searchMoreSubject = PassthroughSubject<(String), Never>() // 무한스크롤 적용
   
   var lastIdOfFollowingSearchResult: Int? = nil
   var hasNextFollowingSearchResult: Bool = true
   
   var lastIdOfFollowerSearchResult: Int? = nil
   var hasNextFollowerSearchResult: Bool = true
   */
  
  // MARK: Init
  init() {
    self.currentFollowType = .following
    
    /// 팔로워 / 팔로잉 리스트 무한스크롤
    fetchMoreSubject.sink { [weak self] userId in
      guard let self = self else { return }
      if !self.isLoading {
        switch currentFollowType {
        case .following:
          self.fetchFollowingUsers(userId: userId) { _ in }
        case .follower:
          self.fetchFollowerUsers(userId: userId) { _ in }
        }
      }
    }.store(in: &subscription)
    
    /// 알 수도 있는 친구 무한스크롤
    suggestMoreSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isLoadingSuggestion {
        self.fetchSuggestedUsers {}
      }
    }.store(in: &subscription)
  }
  
  /// 팔로잉 리스트 조회에 필요한 데이터들 초기화
  private func initFollowingData() {
    followingPage = 0
    hasNextFollowingPage = true
    followingUsers = []
  }
  
  /// 팔로워 리스트 조회에 필요한 데이터들 초기화
  private func initFollowerData() {
    followerPage = 0
    hasNextFollowerPage = true
    followerUsers = []
  }
  
  func initSearchData() {
    initFollowingData()
    initFollowerData()
  }
  
  // MARK: Fetch Follow Users
  
  /// 팔로잉 유저, 팔로워 유저 리스트 첫 번째 페이지를 받아옴
  func initFollowingFollower(userId: Int) {
    initFollowingData()
    initFollowerData()
    
    fetchFollowingUsers(userId: userId) { success in
      if success {
        self.fetchFollowerUsers(userId: userId) { _ in }
      }
    }
  }
  
  /// 팔로잉 유저, 팔로워 유저 리스트 새로고침
  /// 현재 보여지는 리스트만 새로고침됨
  func refreshFollowingFollower(userId: Int) {
    isRefreshing = true
    switch currentFollowType {
    case .following:
      initFollowingData()
      fetchFollowingUsers(userId: userId) { _ in }
    case .follower:
      initFollowerData()
      fetchFollowerUsers(userId: userId) { _ in }
    }
  }
  
  /// 팔로잉 유저 리스트 첫 번째 페이지를 받아옴
  func initFollowingUsers(userId: Int) {
    initFollowingData()
    fetchFollowingUsers(userId: userId) { _ in }
  }
  
  /// 팔로워 유저 리스트 첫 번째 페이지를 받아옴
  func initFollowerUsers(userId: Int) {
    followerUsers = []
    fetchFollowerUsers(userId: userId) { _ in }
  }
  
  /// api를 통해 팔로잉 유저 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수,  sortType: 정렬방식 (최신순 / 오래된순)
  private func fetchFollowingUsers(
    userId: Int,
    size: Int = 20,
    sortType: FollowSortingType = .latest,
    completion: @escaping (Bool) -> Void
  ) {
    
    // all following users are fetched
    if hasNextFollowingPage == false {
      return
    }
    
    // already fetching
    if isLoading {
      return
    }
    
    self.isLoading = true
    followProvider.requestPublisher(
      .getFollowing(userId: userId, page: self.followingPage, size: size, sortType: sortType)
    )
    .sink { apiCompletion in
      self.isLoading = false
      self.isRefreshing = false
      
      switch apiCompletion {
      case .finished:
        self.followingPage += 1
        // print( "fetch \(self.followingPage)th following users: now \(self.followingUsers.count) users are fetched")
        completion(true)
      case .failure(let error):
        self.processErrorResponse(error)
      }
    } receiveValue: { response in
      guard let responseData = try? response.map(FollowUserListResponse.self) else {
        return
      }
      self.hasNextFollowingPage = responseData.hasNext
      self.followingUsers += responseData.content
    }
    .store(in: &subscription)
  }
  
  /// api를 통해 팔로워 유저 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수,  sortType: 정렬방식 (최신순 / 오래된순)
  private func fetchFollowerUsers(
    userId: Int,
    size: Int = 20,
    sortType: FollowSortingType = .latest,
    completion: @escaping (Bool) -> Void
  ) {
    // all follower users are fetched
    if hasNextFollowerPage == false {
      return
    }
    
    // already loading
    if isLoading {
      return
    }
    
    self.isLoading = true
    followProvider.requestPublisher(
      .getFollower(userId: userId, page: self.followerPage, size: size, sortType: sortType)
    )
    .sink { apiCompletion in
      self.isLoading = false
      self.isRefreshing = false
      
      switch apiCompletion {
      case .finished:
        self.followerPage += 1
        // print( "fetch \(self.followerPage)th following users: now \(self.followerUsers.count) users are fetched")
        completion(true)
      case .failure(let error):
        self.processErrorResponse(error)
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
  
  /// 알 수도 있는 친구 추천 리스트 첫 번째 페이지를 받아옴
  func getSuggestion(completion: @escaping (Bool) -> Void) {
    self.lastIdOfSuggestion = nil
    self.hasNextSuggestion = true
    self.suggestedUsers = []
    
    fetchSuggestedUsers() {
      completion(true)
    }
  }
  
  /// api를 통해 알 수도 있는 친구 추천 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수
  private func fetchSuggestedUsers(
    size: Int = 10,
    completion: @escaping () -> Void
  ) {
    // no more suggestion
    if self.hasNextSuggestion == false {
      return
    }
    
    self.isLoadingSuggestion = true
    followProvider.requestPublisher(
      .suggestUser(size: size, lastId: self.lastIdOfSuggestion)
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        self.isLoadingSuggestion = false
        // print("suggest total \(self.suggestedUsers.count) users")
        completion()
      case .failure(let error):
        self.processErrorResponse(error)
      }
    } receiveValue: { response in
      guard let responseData = try? response.map(FollowUserListResponse.self) else {
        // print("Error: following users response decoding error")
        return
      }
      
      self.hasNextSuggestion = responseData.hasNext
      self.suggestedUsers += responseData.content
      if let lastUser = self.suggestedUsers.last {
        self.lastIdOfSuggestion = lastUser.userId
      } else {
        self.lastIdOfSuggestion = nil
      }
    }
    .store(in: &subscription)
  }
  
  // MARK: Search Users By Nickname
  
  /// 닉네임으로 팔로워/팔로잉 유저 검색
  func searchFollowUsers(
    by nickname: String,
    userId: Int
  ) {
    followingSearchResult = []
    followerSearchResult = []
    
    /*
    lastIdOfFollowingSearchResult = nil
    hasNextFollowingSearchResult = true
    lastIdOfFollowerSearchResult = nil
    hasNextFollowerSearchResult = true
     */
    
    searchFollowingUsers(by: nickname, userId: userId) { success in
      if success {
        self.searchFollowerUsers(by: nickname, userId: userId) { _ in }
      }
    }
  }
  
  /// 닉네임으로 팔로잉 유저 검색
  func searchFollowingUsers(by nickname: String,
                            userId: Int,
                            completion: @escaping (Bool) -> Void) {
    isLoadingSearchResult = true
    
    if hasNextFollowingPage {
      // TODO: 팔로잉 수가 많을 경우 검색 api 사용
      
      // 팔로잉 수가 많지 않을 경우 fetchAll로 가져온 데이터에서 검색
      fetchAllFollowingUsers(userId: userId) { [self] allUsers in
        followingSearchResult = allUsers.filter {
          $0.nickname.localizedCaseInsensitiveContains(nickname)
        }
        isLoadingSearchResult = false
        completion(true)
      }
    }
    
    // 이미 팔로잉 리스트를 모두 가져온 상태인 경우
    else {
      followingSearchResult = followingUsers.filter {
        $0.nickname.localizedCaseInsensitiveContains(nickname)
      }
      isLoadingSearchResult = false
      completion(true)
    }
    
    /*
     fetchSearchedFollowings(by: nickname, result: searchedUsers) { result in
     followingResult = result
     }
     */
  }
  
  /// 닉네임으로 팔로워 유저 검색
  private func searchFollowerUsers(by nickname: String,
                                   userId: Int,
                                   completion: @escaping (Bool) -> Void) {
    isLoadingSearchResult = true
    
    if hasNextFollowerPage {
      // TODO: 팔로워 수가 많을 경우 검색 api 사용
      
      // 팔로워 수가 많지 않을 경우 fetchAll로 가져온 데이터에서 검색
      fetchAllFollowerUsers(userId: userId) { [self] allUsers in
        followerSearchResult = allUsers.filter { searchedUser in
          searchedUser.nickname.localizedCaseInsensitiveContains(nickname)
          && followingSearchResult.filter({ $0.userId == searchedUser.userId }).isEmpty
        }
        isLoadingSearchResult = false
        completion(true)
      }
    }
    
    // 이미 팔로워 리스트를 모두 가져온 상태인 경우
    else {
      followerSearchResult = followerUsers.filter { searchedUser in
        searchedUser.nickname.localizedCaseInsensitiveContains(nickname)
        && followingSearchResult.filter({ $0.userId == searchedUser.userId }).isEmpty
      }
      isLoadingSearchResult = false
      completion(true)
    }
    /*
     fetchSearchedFollowings(by: nickname, result: searchedUsers) { result in
     followingResult = result
     }
     */
  }
  
  // MARK: fetch All Users to Search
  /// 모든 팔로잉 유저를 받아옴
  private func fetchAllFollowingUsers(userId: Int,
                                      completion: @escaping ([FollowUserData]) -> Void) {
    var allFollowingUsers: [FollowUserData] = []
    
    func fetchNextPage() {
      fetchFollowingUsers(userId: userId, size: 100) { success in
        if success {
          if self.hasNextFollowingPage {
            fetchNextPage()
          } else {
            // print("get all following users")
            allFollowingUsers = self.followingUsers
            completion(allFollowingUsers)
          }
        } else {
          completion([])
        }
      }
    }
    
    fetchNextPage()
  }
  
  /// 모든 팔로워 유저를 받아옴
  private func fetchAllFollowerUsers(userId: Int,
                                     completion: @escaping ([FollowUserData]) -> Void) {
    var allFollowerUsers: [FollowUserData] = []
    
    func fetchNextPage() {
      fetchFollowerUsers(userId: userId, size: 100) { success in
        if success {
          if self.hasNextFollowerPage {
            fetchNextPage()
          } else {
            print("get all follower users")
            allFollowerUsers = self.followerUsers
            completion(allFollowerUsers)
          }
        } else {
          completion([])
        }
      }
    }
    
    fetchNextPage()
  }
  
  
  /*
  /// api를 이용해 팔로잉 검색
  private func fetchSearchedFollowings(by nickname: String,
                                       userId: Int,
                                       completion: @escaping (Bool) -> Void) {
    // already fetching
    if self.isLoadingSearchResult {
      return
    }
    
    self.isLoadingSearchResult = true
    followProvider.requestPublisher(
      .searchFollowingByNickname(userId: userId,
                                 nickname: nickname,
                                 lastId: lastIdOfFollowingSearchResult))
      .sink { apiCompletion in
        self.isLoadingSearchResult = false
        
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
        }
      } receiveValue: { response in
        guard let responseData = try? response.map(FollowUserListResponse.self) else {
          print("Error: following users response decoding error")
          return
        }
        
        self.hasNextFollowingSearchResult = responseData.hasNext
        self.followingSearchResult += responseData.content
        if let lastUser = responseData.content.last {
          self.lastIdOfFollowingSearchResult = lastUser.userId
        } else {
          self.lastIdOfFollowingSearchResult = nil
        }
      }.store(in: &subscription)
  }
  
   /// api를 이용해 팔로워 검색
  private func fetchSearcedFollowers(by nickname: String,
                                     userId: Int,
                                     completion: @escaping (Bool) -> Void) {
    // already fetching
    if self.isLoadingSearchResult {
      return
    }
    
    self.isLoadingSearchResult = true
    followProvider.requestPublisher(
      .searchFollowerByNickname(userId: userId,
                                nickname: nickname,
                                lastId: self.lastIdOfFollowerSearchResult))
      .sink { apiCompletion in
        self.isLoadingSearchResult = false
        
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
        }
      } receiveValue: { response in
        guard let responseData = try? response.map(FollowUserListResponse.self) else {
          print("Error: following users response decoding error")
          return
        }
        
        self.hasNextFollowerSearchResult = responseData.hasNext
        self.followerSearchResult += responseData.content
        if let lastUser = responseData.content.last {
          self.lastIdOfFollowerSearchResult = lastUser.userId
        } else {
          self.lastIdOfFollowerSearchResult = nil
        }
      }.store(in: &subscription)
  }
  */
  
  // MARK: Error Handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in follow hub view model - \(errorData.message)")
    } else {  // unknown error
      print("in follow hub view model - \(error)")
    }
  }
}
