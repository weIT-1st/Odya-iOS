//
//  MyCommunityActivityViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/14.
//

import Combine
import Moya
import SwiftUI

final class MyCommunityActivityViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 게시글 리스트 저장
  struct FeedState {
    var content: [MyCommunityContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  /// 댓글 리스트 저장
  struct CommentState {
    var content: [MyCommunityCommentsContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  /// 좋아요 리스트 저장
  struct LikeState {
    var content: [MyCommunityContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var feedState = FeedState()
  @Published private(set) var commentState = CommentState()
  @Published private(set) var likeState = LikeState()

  /// 네트워크 통신중 flag
  @Published var isProcessing: Bool = false
  
  // MARK: - Helper functions
  
  /// 내 커뮤니티 활동 - 게시글 불러오기
  func fetchMyFeedNextPageIfPossible() {
    guard feedState.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(.getMyCommunity(size: nil, lastId: feedState.lastId, sortType: nil))
      .sink { [self] completion in
        switch completion {
        case .finished:
          debugPrint("내 커뮤니티 활동 - 게시물 조회 완료. 다음 페이지 \(self.feedState.canLoadNextPage)")
        case .failure(let error):
          handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(MyCommunity.self) {
          self.feedState.content += data.content
          self.feedState.lastId = data.content.last?.communityID
          self.feedState.canLoadNextPage = data.hasNext
        }
      }
      .store(in: &subscription)
  }
  
  /// 내 커뮤니티 활동 - 댓글 불러오기
  func fetchMyCommentsNextPageIfPossible() {
    guard commentState.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(.getMyComments(size: nil, lastId: commentState.lastId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("내 커뮤니티 활동 - 댓글 조회 완료. 다음 페이지 \(self.commentState.canLoadNextPage)")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(MyCommunityComments.self) {
          self.commentState.content += data.content
          self.commentState.lastId = data.content.last?.communityID
          self.commentState.canLoadNextPage = data.hasNext
        }
      }
      .store(in: &subscription)
  }
  
  /// 내 커뮤니티 활동 - 좋아요한 게시글 불러오기
  func fetchMyLikesNextPageIfPossible() {
    guard likeState.canLoadNextPage else { return }
    
    communityProvider.requestPublisher(.getMyLikes(size: nil, lastId: likeState.lastId, sortType: nil))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("내 커뮤니티 활동 - 좋아요한 게시글 조회 완료. 다음 페이지 \(self.likeState.canLoadNextPage)")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(MyCommunity.self) {
          self.likeState.content += data.content
          self.likeState.lastId = data.content.last?.communityID
          self.likeState.canLoadNextPage = data.hasNext
        }
      }
      .store(in: &subscription)
  }
  
  /// API 에러 처리
  func handleErrorData(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("\(errorData.code): \(errorData.message)")
    } else {
      print("알 수 없는 오류 발생")
    }
  }
}
