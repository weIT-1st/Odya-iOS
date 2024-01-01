//
//  LinkedTravelJournalViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import Combine
import Moya
import SwiftUI

final class LinkedTravelJournalViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// Loading
  @Published var isLoading: Bool = false
  /// 공개로 전환중일때
  @Published var isSwitchProgressing: Bool = false
  /// 여행일지가 없는 경우 alert
  @Published var showNoJournalAlert = false
  
  /// 내 여행일지 목록 정보
  struct JournalState {
    var content: [TravelJournalData] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var state = JournalState()
  
  // MARK: - Helper functions
  /// 나의 여행일지 목록 가져오기
  func fetchMyJournalListNextPageIfPossible() {
    guard state.canLoadNextPage else { return }
    isLoading = true
    
    journalProvider.requestPublisher(.getMyJournals(token: idToken ?? "", size: nil, lastId: state.lastId))
      .sink { completion in
        switch completion {
        case .finished:
          print("내 여행일지 조회 완료 - 다음 페이지 \(self.state.canLoadNextPage)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
          self.state.canLoadNextPage = false
        }
        self.isLoading = false
      } receiveValue: { response in
        if let data = try? response.map(TravelJournalList.self) {
          self.state.content += data.content
          self.state.lastId = data.content.last?.journalId
          self.state.canLoadNextPage = data.hasNext
          
          if self.state.content.isEmpty {
            self.showNoJournalAlert = true
          }
        }
      }
      .store(in: &subscription)
  }
  
  /// 나의 여행일지 목록 새로고침
  func refreshMyJournalList() {
    self.state = JournalState()
    fetchMyJournalListNextPageIfPossible()
  }
  
  /// 여행일지 공개 범위 수정 - PUBLIC
  func switchVisibilityToPublic(journalId id: Int) {
    isLoading = true
    
    journalProvider.requestPublisher(.updateVisibility(token: idToken ?? "", journalId: id, visibility: "PUBLIC"))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("여행일지 \(id) 공개로 변경 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
        self.isLoading = false
        self.refreshMyJournalList()
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}
