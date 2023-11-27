//
//  TopicListViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/31.
//

import Combine
import Moya
import SwiftUI

final class TopicListViewModel: ObservableObject {
  // MARK: Properties

  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var topicProvider = MoyaProvider<TopicRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  /// 토픽 리스트 저장
  @Published var topicList: [Topic] = []

  // MARK: - Read
  /// 토픽 리스트 조회
  func fetchTopicList() {
    topicProvider.requestPublisher(.getTopicList)
      .sink { completion in
        switch completion {
        case .finished:
          print("토픽 리스트 조회")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(TopicList.self) {
          self.topicList = data
        }
      }
      .store(in: &subscription)
  }
}
