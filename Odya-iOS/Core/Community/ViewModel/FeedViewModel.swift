//
//  FeedViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/12.
//

import Combine
import Moya
import SwiftUI

final class FeedViewModel: ObservableObject {
  // MARK: Properties
  
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 피드 내용, 페이지 정보 저장
  struct FeedState {
    var content: [FeedContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var state = FeedState()
  
  // MARK: - Read
  
  /// 커뮤니티 전체게시글 조회
  func fetchAllFeedNextPageIfPossible() {
    guard state.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(
      .getAllCommunity(
        size: 10, lastId: state.lastId, sortType: FeedSortType.lastest.rawValue)
    )
    .sink { completion in
      switch completion {
      case .finished:
        print("전체 피드 조회 완료 - 다음 페이지 \(self.state.canLoadNextPage)")
      case .failure(let error):
        if let errorData = try? error.response?.map(ErrorData.self) {
          print(errorData.message)
        }
        self.state.canLoadNextPage = false
      }
    } receiveValue: { response in
      if let data = try? response.map(Feed.self) {
        self.state.content += data.content
        self.state.lastId = data.content.last?.communityID
        self.state.canLoadNextPage = data.hasNext
      }
    }
    .store(in: &subscription)
  }
  
  /// 전체글 새로고침
  func refreshAllFeed() {
    self.state = FeedState()
    fetchAllFeedNextPageIfPossible()
  }
  
  /// 커뮤니티 친구글 조회
  func fetchFriendFeedNextPageIfPossible() {
    guard state.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(
      .getFriendsCommunity(
        size: 10, lastId: state.lastId ?? nil, sortType: FeedSortType.lastest.rawValue)
    )
    .sink { completion in
      switch completion {
      case .finished:
        print("친구글 피드 조회 완료 - 다음 페이지 \(self.state.canLoadNextPage)")
      case .failure(let error):
        if let errorData = try? error.response?.map(ErrorData.self) {
          print(errorData.message)
        }
      }
    } receiveValue: { response in
      if let data = try? response.map(Feed.self) {
        self.state.content += data.content
        self.state.lastId = data.content.last?.communityID
        self.state.canLoadNextPage = data.hasNext
      }
    }
    .store(in: &subscription)
  }
  
  /// 친구글 새로고침
  func refreshFriendFeed() {
    self.state = FeedState()
    fetchFriendFeedNextPageIfPossible()
  }
  
  /// 토픽으로 전체글 조회
  func fetchTopicFeedNextPageIfPossible(topicId: Int) {
    guard state.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(.getAllCommunityByTopic(size: 10, lastId: state.lastId ?? nil, sortType: FeedSortType.lastest.rawValue, topicId: topicId))
      .sink { completion in
        switch completion {
        case .finished:
          print("토픽 아이디\(topicId) 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(Feed.self) {
          self.state.content += data.content
          self.state.lastId = data.content.last?.communityID
          self.state.canLoadNextPage = data.hasNext
          print(self.state.content)
        }
      }
      .store(in: &subscription)
    
  }
  
  /// 토픽글 새로고침
  func refreshTopicFeed(topicId: Int) {
    self.state = FeedState()
    fetchTopicFeedNextPageIfPossible(topicId: topicId)
  }
}
