//
//  RankViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/02.
//

import Combine
import Moya
import SwiftUI

final class RankViewModel: ObservableObject {
  // MARK: - Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var rankProvider = MoyaProvider<PlaceSearchHistoryRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 핫플 순위 리스트
  @Published var rankingList = [String]()
  
  // MARK: - Helper functions
  
  /// 전체 순위 불러오기
  func fetchEntireRanking() {
    rankProvider.requestPublisher(.getEntireRanking)
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("전체 랭킹 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map([String].self) {
          self.rankingList = data
        }
      }
      .store(in: &subscription)
  }
}
