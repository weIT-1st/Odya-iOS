//
//  FollowListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import Combine
import CombineMoya
import Foundation
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

  @Published var currentFollowType: FollowType
  @Published var followCount: FollowCount

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

  /*/ 닉네임 검색 api 사용 시 필요
    var searchMoreSubject = PassthroughSubject<(String), Never>() // 무한스크롤 적용

    var lastIdOfFollowingSearchResult: Int? = nil
    var hasNextFollowingSearchResult: Bool = true

    var lastIdOfFollowerSearchResult: Int? = nil
    var hasNextFollowerSearchResult: Bool = true
     */

  // MARK: Init

  init(token: String, userID: Int, followCount: FollowCount) {
    self.idToken = token
    self.userID = userID
    self.followCount = followCount
    self.currentFollowType = .following

    /// 팔로워 / 팔로잉 리스트 무한스크롤
    fetchMoreSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isLoading {
        switch currentFollowType {
        case .following:
          self.fetchFollowingUsers { _ in }
        case .follower:
          self.fetchFollowingUsers { _ in }
        }
      }
    }.store(in: &subscription)

    /// 알 수도 있는 친구 무한스크롤
    suggestMoreSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isLoadingSuggestion {
        self.suggestUsers { _ in }
      }
    }.store(in: &subscription)

  }

  // MARK: follow / unfollow

  /// 팔로우 실행
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
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  /// 언팔로우 실행
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
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  // MARK: Fetch Follow Users

  /// 팔로잉 유저 리스트 첫 번째 페이지를 받아옴
    func initFollowingUsers(completion: @escaping (Bool) -> Void) {
        followingPage = 0
        hasNextFollowingPage = true
        followingUsers = []
        
        fetchFollowingUsers { _ in
            completion(true)
        }
    }

  /// 팔로워 유저 리스트 첫 번째 페이지를 받아옴
    func initFollowerUsers(completion: @escaping (Bool) -> Void) {
        followerPage = 0
        hasNextFollowerPage = true
        followerUsers = []
        
        fetchFollowerUsers { _ in
            completion(true)
        }
    }

  /// api를 통해 팔로잉 유저 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수,  sortType: 정렬방식 (최신순 / 오래된순)
    private func fetchFollowingUsers(size: Int = 20, sortType: FollowSortingType = .latest, completion: @escaping (Bool) -> Void) {
        if self.hasNextFollowingPage == false {
            print("all following users are fetched")
            return
        }
        
        if self.isLoading {
            // print("following users are already loading")
            return
        }
        
        self.isLoading = true
        
        followProvider.requestPublisher(
            .getFollowing(
                token: self.idToken, userID: self.userID, page: self.followingPage, size: size,
                sortType: sortType)
        )
        .sink { apiCompletion in
            self.isLoading = false
            self.isRefreshing = false
            
            switch apiCompletion {
            case .finished:
                self.followingPage += 1
                 print("fetch \(self.followingPage)th following users: now \(self.followingUsers.count) users are fetched")
                completion(true)
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

  /// api를 통해 팔로워 유저 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수,  sortType: 정렬방식 (최신순 / 오래된순)
  private func fetchFollowerUsers(size: Int = 20, sortType: FollowSortingType = .latest, completion: @escaping (Bool) -> Void
  ) {
    if self.hasNextFollowerPage == false {
      print("all follower users are fetched")
      return
    }
      
      if self.isLoading {
          print("follower users are already loading")
          return
      }

    self.isLoading = true

    followProvider.requestPublisher(
      .getFollower(
        token: self.idToken, userID: self.userID, page: self.followerPage, size: size,
        sortType: sortType)
    )
    .sink { apiCompletion in
      self.isLoading = false
      self.isRefreshing = false

      switch apiCompletion {
      case .finished:
        self.followerPage += 1
         print("fetch \(self.followerPage)th following users: now \(self.followerUsers.count) users are fetched")
        completion(true)
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

  /// 알 수도 있는 친구 추천 리스트 첫 번째 페이지를 받아옴
  func getSuggestion(completion: @escaping (Bool) -> Void) {
    self.lastIdOfSuggestion = nil
    self.hasNextSuggestion = true
    self.suggestedUsers = []

    suggestUsers { _ in
      completion(true)
    }
  }

  /// api를 통해 알 수도 있는 친구 추천 리스트를 받아오는 함수
  /// size: 한 페이지에 포함된 유저 수
  private func suggestUsers(
    size: Int = 10,
    completion: @escaping (Bool) -> Void
  ) {
    if self.hasNextSuggestion == false {
      print("no more suggestion")
      return
    }

    self.isLoadingSuggestion = true

    followProvider.requestPublisher(
      .suggestUser(token: self.idToken, size: size, lastID: self.lastIdOfSuggestion)
    )
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        self.isLoadingSuggestion = false
        // print("suggest total \(self.suggestedUsers.count) users")
        completion(true)
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
    func searchFollowUsers(by nickname: String,
                           completion: @escaping (Bool) -> Void) {
        followingSearchResult = []
        followerSearchResult = []
        
        searchFollowingUsers(by: nickname) { success in
            if success {
                self.searchFollowerUsers(by: nickname) { success in
                    if success {
                        completion(true)
                    }
                }
            }
        }
    }

    /// 닉네임으로 팔로잉 유저 검색
    func searchFollowingUsers(by nickname: String, completion: @escaping (Bool) -> Void) {
        isLoadingSearchResult = true

        if hasNextFollowingPage {
            fetchAllFollowingUsers() { [self] allUsers in
                followingSearchResult = allUsers.filter {
                    $0.nickname.localizedCaseInsensitiveContains(nickname)
                }
                isLoadingSearchResult = false
                completion(true)
            }
        } else {   
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
    private func searchFollowerUsers(by nickname: String, completion: @escaping (Bool) -> Void) {
        isLoadingSearchResult = true

        if hasNextFollowerPage {
            fetchAllFollowerUsers() { [self] allUsers in
                followerSearchResult = allUsers.filter { searchedUser in
                    searchedUser.nickname.localizedCaseInsensitiveContains(nickname)
                    && followingSearchResult.filter({ $0.userId == searchedUser.userId}).isEmpty
                }
                isLoadingSearchResult = false
                completion(true)
            }
        } else {
            followerSearchResult = followerUsers.filter { searchedUser in
                searchedUser.nickname.localizedCaseInsensitiveContains(nickname)
                && followingSearchResult.filter({ $0.userId == searchedUser.userId}).isEmpty
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
    
    /// 모든 팔로잉 유저를 받아옴
    private func fetchAllFollowingUsers(completion: @escaping ([FollowUserData]) -> Void) {
        var allFollowingUsers: [FollowUserData] = []

        func fetchNextPage() {
            fetchFollowingUsers(size: 100) { success in
                if success {
                    if self.hasNextFollowingPage {
                        fetchNextPage()
                    } else {
                        print("get all following users")
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
    private func fetchAllFollowerUsers(completion: @escaping ([FollowUserData]) -> Void) {
        var allFollowerUsers: [FollowUserData] = []

        func fetchNextPage() {
            fetchFollowerUsers(size: 100) { success in
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
    private func fetchSearchedFollowings(by nickname: String,
                                         result: [FollowUserData],
                                         completion: @escaping ([FollowUserData]) -> Void) {
        if self.isLoadingSearchResult {
            return
        }

        self.isLoadingSearchResult = true
        var newResult = result

        followProvider.requestPublisher(.searchFollowingByNickname(token: self.idToken, nickname: nickname, lastID: self.lastIdOfFollowingSearchResult))
            .sink { apiCompletion in
                switch apiCompletion {
                case .finished:
                    self.isLoadingSearchResult = false
                    completion(newResult)
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

                self.hasNextFollowingSearchResult = responseData.hasNext
                for newUser in responseData.content {
                    if !result.contains(newUser) {
                        newResult.append(newUser)
                    }
                }
                if let lastUser = responseData.content.last {
                    self.lastIdOfFollowingSearchResult = lastUser.userId
                } else {
                    self.lastIdOfFollowingSearchResult = nil
                }
            }.store(in: &subscription)
    }

    private func fetchSearcedFollowers(by nickname: String,
                                       result: [FollowUserData],
                                       completion: @escaping ([FollowUserData]) -> Void) {
        if self.isLoadingSearchResult {
            return
        }

        self.isLoadingSearchResult = true
        var newResult = result

        followProvider.requestPublisher(.searchFollowerByNickname(token: self.idToken, nickname: nickname, lastID: self.lastIdOfFollowerSearchResult))
            .sink { apiCompletion in
                switch apiCompletion {
                case .finished:
                    self.isLoadingSearchResult = false
                    completion(newResult)
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

                self.hasNextFollowerSearchResult = responseData.hasNext
                for newUser in responseData.content {
                    if !result.contains(newUser) {
                        newResult.append(newUser)
                    }
                }
                if let lastUser = responseData.content.last {
                    self.lastIdOfFollowerSearchResult = lastUser.userId
                } else {
                    self.lastIdOfFollowerSearchResult = nil
                }
            }.store(in: &subscription)
    }
     */
}
