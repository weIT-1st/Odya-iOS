//
//  CommentViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/14.
//

import Combine
import Moya
import SwiftUI

class CommentViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var commentProvider = MoyaProvider<CommunityCommentRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 전체 댓글 내용, 페이지 정보 저장
  struct CommentState {
    var content: [CommentContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  /// 전체 댓글 상태
  @Published private(set) var state = CommentState()
  
  // 댓글 전체보기 프로퍼티
  /// 입력한 댓글 텍스트
  @Published var newCommentText: String = ""
  @Published var hasTextFieldFocus: Bool = false
  /// 네트워크 통신중 flag
  @Published var isProcessing: Bool = false
  
  // MARK: - CRUD
  /// 댓글 생성
  func createComment(communityId: Int) {
    isProcessing = true
    
    commentProvider.requestPublisher(.createComment(communityId: communityId, content: newCommentText))
      .sink { completion in
        switch completion {
        case .finished:
          print("댓글 생성 완료")
          self.newCommentText = ""
          self.state.canLoadNextPage = true
          self.fetchCommentNextPageIfPossible(communityId: communityId)
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
        
        self.isProcessing = false
      } receiveValue: { response in
        
      }
      .store(in: &subscription)
  }
  
  /// 댓글 조회
  func fetchCommentNextPageIfPossible(communityId: Int, size: Int = 10) {
    guard state.canLoadNextPage else { return }
    
    commentProvider.requestPublisher(.getComment(communityId: communityId, size: size, lastId: state.lastId ?? nil))
      .sink { completion in
        switch completion {
        case .finished:
          print("댓글 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(Comment.self) {
          self.state.content += data.content
          self.state.lastId = data.content.last?.communityCommentID
          self.state.canLoadNextPage = data.hasNext
        }
      }
      .store(in: &subscription)
  }
  
  /// 댓글 수정
  
  /// 댓글 삭제
}
