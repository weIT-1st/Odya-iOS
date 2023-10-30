//
//  FeedDetailViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/30.
//

import Combine
import Moya
import SwiftUI

final class FeedDetailViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  /// 피드 디테일
  @Published var feedDetail: FeedDetail!

  // MARK: - Read
  /// 게시글 상세조회
  func fetchFeedDetail(id: Int) {
    communityProvider.requestPublisher(.getCommunityDetail(communityId: id))
      .sink { completion in
        switch completion {
        case .finished:
          print("피드 디테일 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(FeedDetail.self) {
          self.feedDetail = data
        }
      }
      .store(in: &subscription)
  }
}
