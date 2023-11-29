//
//  FeedUserSearchViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/29.
//

import Combine
import Moya
import SwiftUI

final class FeedUserSearchViewModel: ObservableObject {
  // MARK: - Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 검색된 유저 리스트 저장
  struct SearchedUserState {
    var content: [SearchedUserContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var state = SearchedUserState()
  
  // MARK: - Helper functions
  
  /// 유저 검색
  func searchUserNextPageIfPossible(query: String) {
    guard state.canLoadNextPage else { return }
    
    subscription.forEach { $0.cancel() }
    
    userProvider.requestPublisher(.searchUser(size: 10, lastId: state.lastId, nickname: query))
      .sink { completion in
        switch completion {
        case .finished:
          print("유저 검색 완료 - 다음 페이지 \(self.state.canLoadNextPage)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(SearchedUser.self) {
          self.state.content += data.content
          self.state.lastId = data.content.last?.userId
          self.state.canLoadNextPage = data.hasNext
        }
      }
      .store(in: &subscription)
  }
  
  func initiateState() {
    state = SearchedUserState()
  }
}
