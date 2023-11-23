//
//  CommunityLikeViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/17.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

class CommunityLikeViewModel: ObservableObject {
  // MARK: Properties
  
  /// provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityLikeRouter = MoyaProvider<CommunityLikeRouter>(plugins: [authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // MARK: - Create, Delete Like
  
  /// 커뮤니티 좋아요 생성
  func createLike(communityId: Int) {
    communityLikeRouter.requestPublisher(.createLike(communityId: communityId))
      .sink { completion in
        switch completion {
        case .finished:
          print("커뮤니티 좋아요 생성 \(communityId)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  /// 커뮤니티 좋아요 삭제
  func deleteLike(communityId: Int) {
    communityLikeRouter.requestPublisher(.deleteLike(communityId: communityId))
      .sink { completion in
        switch completion {
        case .finished:
          print("커뮤니티 좋아요 삭제 \(communityId)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}
