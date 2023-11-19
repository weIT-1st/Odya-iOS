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
  @Published var nickname: String = MyData().nickname
  @Published var profile: ProfileData = MyData().profile.decodeToProileData()
  var userId: Int = MyData.userID

  // loadingFlag
  @Published var isMyJournalsLoading: Bool = false
  var isBookmarkedJournalsLoading: Bool = false
  var isTaggedJournalsLoading: Bool = false

  // travel journals
  // @Published var randomJournal: TravelJournalData
  @Published var myJournals: [TravelJournalData] = []
  @Published var bookmarkedJournals: [BookmarkedJournalData] = []
  @Published var taggedJournals: [TaggedJournalData] = []
  // 내가 쓴 한글리뷰 리스트

  // flags for Infinite Scroll
  var lastIdOfMyJournals: Int? = nil
  var hasNextMyJournals: Bool = true
  var lastIdOfBookmarkedJournals: Int? = nil
  var hasNextBookmarkedJournals: Bool = true
  var lastIdOfTaggedJournals: Int? = nil
  var hasNextTaggedJournals: Bool = true

  // MARK: Get My Data

  /// user defaults에서 유저 정보 가져옴
  func getMyData() {
    let myData = MyData()
    self.nickname = myData.nickname
    self.profile = myData.profile.decodeToProileData()
    self.userId = MyData.userID
  }

  // MARK: Fetch Data

  /// Fetch Data를 하기 전 초기화
  func initData() {
    // travel journals
    // @Published var randomJournal: TravelJournalData
    myJournals = []
    bookmarkedJournals = []
    taggedJournals = []
    // 내가 쓴 한글리뷰 리스트

    // flags for Infinite Scroll
    lastIdOfMyJournals = nil
    hasNextMyJournals = true
    lastIdOfBookmarkedJournals = nil
    hasNextBookmarkedJournals = true
    lastIdOfTaggedJournals = nil
    hasNextTaggedJournals = true
  }

  /// api를 통해 여행일지들을 가져옴
  /// 내 여행일지, 즐겨찾기된 여행일지, 테그된 여행일지 가져올 수 있음
  func fetchDataAsync() async {
    guard let idToken = idToken else {
      return
    }

    getMyJournals(idToken: idToken)
    getBookmarkedJournals(idToken: idToken)
    getTaggedJournals(idToken: idToken)
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

  // MARK: Get Bookmarked Journals
  
  func updateBookmarkedJournals() {
    guard let idToken = idToken else {
      return
    }
    
    isBookmarkedJournalsLoading = false
    hasNextBookmarkedJournals = true
    lastIdOfBookmarkedJournals = nil
    bookmarkedJournals = []
    
    getBookmarkedJournals(idToken: idToken)
  }

  private func getBookmarkedJournals(idToken: String) {
    if isBookmarkedJournalsLoading || !hasNextBookmarkedJournals {
      return
    }

    self.isBookmarkedJournalsLoading = true
    journalProvider.requestPublisher(
      .getBookmarkedJournals(token: idToken, size: nil, lastId: self.lastIdOfBookmarkedJournals)
    )
    .filterSuccessfulStatusCodes()
    .sink { completion in
      switch completion {
      case .finished:
        self.isBookmarkedJournalsLoading = false
      case .failure(let error):
        self.isBookmarkedJournalsLoading = false

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
        let responseData = try response.map(BookmarkedJournalList.self)
        self.hasNextBookmarkedJournals = responseData.hasNext
        self.bookmarkedJournals += responseData.content
        self.lastIdOfBookmarkedJournals = responseData.content.last?.journalId
      } catch {
        return
      }
    }.store(in: &subscription)
  }

  // MARK: Get Tagged Journals

  private func getTaggedJournals(idToken: String) {
    if isTaggedJournalsLoading || !hasNextTaggedJournals {
      return
    }

    self.isTaggedJournalsLoading = true
    journalProvider.requestPublisher(
      .getTaggedJournals(token: idToken, size: nil, lastId: self.lastIdOfTaggedJournals)
    )
    .filterSuccessfulStatusCodes()
    .sink { completion in
      switch completion {
      case .finished:
        self.isTaggedJournalsLoading = false
      case .failure(let error):
        self.isTaggedJournalsLoading = false

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
        let responseData = try response.map(TaggedJournalList.self)
        self.hasNextTaggedJournals = responseData.hasNext
        self.taggedJournals += responseData.content
        self.lastIdOfTaggedJournals = responseData.content.last?.journalId
      } catch {
        return
      }
    }.store(in: &subscription)
  }

}
