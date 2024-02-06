//
//  MyJournalsViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/18.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class MyJournalsViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()

  // user info
  @AppStorage("WeITAuthToken") var idToken: String?
  @Published var nickname: String = MyData.nickname
  @Published var profile: ProfileData = MyData.profile.decodeToProileData()
  var userId: Int = MyData.userID

  // data
  @Published var myJournals: [TravelJournalData] = []
  // 내가 쓴 한글리뷰 리스트

  // loading flag
  @Published var isMyJournalsLoading: Bool = false

  // infinite Scroll
  @Published var lastIdOfMyJournals: Int? = nil
  var hasNextMyJournals: Bool = true
  var fetchMoreMyJournalsSubject = PassthroughSubject<(), Never>()

  init() {
    fetchMoreMyJournalsSubject
      .sink { [weak self] _ in
        guard let self = self,
          let idToken = self.idToken
        else {
          return
        }
        self.getMyJournals(idToken: idToken)
      }.store(in: &subscription)
  }

  // MARK: Get My Data

  /// user defaults에서 유저 정보 가져옴
  func getMyData() {
    self.nickname = MyData.nickname
    self.profile = MyData.profile.decodeToProileData()
    self.userId = MyData.userID
  }

  // MARK: Fetch Data

  /// Fetch Data를 하기 전 초기화
  func initData() {
    // travel journals
    myJournals = []
    // 내가 쓴 한글리뷰 리스트

    // flags for Infinite Scroll
    lastIdOfMyJournals = nil
    hasNextMyJournals = true
  }

  /// api를 통해 여행일지들을 가져옴
  /// 내 여행일지, 즐겨찾기된 여행일지, 테그된 여행일지 가져올 수 있음
  func fetchDataAsync() async {
    guard let idToken = idToken else {
      return
    }

    getMyJournals(idToken: idToken)
  }

  // MARK: Get My Journals

  private func getMyJournals(idToken: String) {
    if isMyJournalsLoading || !hasNextMyJournals {
      return
    }

    DispatchQueue.main.async {
      self.isMyJournalsLoading = true
    }

    journalProvider.requestPublisher(
      .getMyJournals(token: idToken, size: nil, lastId: self.lastIdOfMyJournals)
    )
    .filterSuccessfulStatusCodes()
    .sink { completion in
      switch completion {
      case .finished:
        self.isMyJournalsLoading = false
      case .failure(let error):
        self.isMyJournalsLoading = false

        guard let apiError = try? error.response?.map(ErrorData.self) else {
          // error data decoding error handling
          // unknown error
          return
        }

        if apiError.code == -11000 {
          self.appDataManager.refreshToken { success in
            // token error handling
            if success {
              self.getMyData()
              return
            }

          }

        }
      // other api error handling
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(TravelJournalList.self)
        self.hasNextMyJournals = responseData.hasNext
        self.myJournals += responseData.content
        self.lastIdOfMyJournals = responseData.content.last?.journalId
      } catch {
        return
      }
    }.store(in: &subscription)
  }
}
