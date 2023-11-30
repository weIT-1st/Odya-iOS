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
  @Published var isLoading: Bool = false
  @Published var userList = SearchUserData.recentSearchUser
  
  // MARK: - Search
  
  /// 유저 검색
  func searchUserNextPageIfPossible(query: String) {
    guard state.canLoadNextPage else { return }
    
    isLoading = true
    subscription.forEach { $0.cancel() }
    
    userProvider.requestPublisher(.searchUser(size: 10, lastId: state.lastId, nickname: query))
      .sink { completion in
        switch completion {
        case .finished:
          print("유저 검색 완료 - 다음 페이지 \(self.state.canLoadNextPage)")
          self.isLoading = false
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
          self.isLoading = false
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
  
  /// 검색결과 초기화
  func initiateState() {
    state = SearchedUserState()
  }
  
  // MARK: - Handle recent search
  
  /// 최근 유저 검색목록에 유저 추가
  func appendRecentSearch(user: SearchedUserContent) {
    guard let _ = userList else {
      SearchUserData.recentSearchUser = [user]
      return
    }
    
    removeRecentSearch(user: user)
    userList?.append(user)
    limitNumberOfRecentSearch()
    SearchUserData.recentSearchUser = userList
  }
  
  /// 최근 유저 검색목록에서 유저 삭제
  func removeRecentSearch(user: SearchedUserContent) {
    if let index = userList?.firstIndex(of: user) {
      userList?.remove(at: index)
      SearchUserData.recentSearchUser = userList
    }
  }
  
  /// 최대 20개까지 유저검색목록 유지
  func limitNumberOfRecentSearch() {
    guard let count = userList?.count else { return }
    if count > 20 {
      userList?.removeFirst()
    }
  }
}
