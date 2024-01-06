//
//  JournalsInProfileViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class JournalsInProfileViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var journalProvider = MoyaProvider<TravelJournalBookmarkRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  let isMyProfile: Bool
  let userId: Int
  
  // loadingFlag
  var isBookmarkedJournalsLoading: Bool = false

  // travel journals
  @Published var bookmarkedJournals: [BookmarkedJournalData] = []

  // flags for Infinite Scroll
  @Published var lastIdOfBookmarkedJournals: Int? = nil
  var hasNextBookmarkedJournals: Bool = true
  var fetchMoreSubject = PassthroughSubject<(), Never>()
  
  init(isMyProfile: Bool, userId: Int) {
    self.isMyProfile = isMyProfile
    self.userId = userId
    
    fetchMoreSubject.sink{ [weak self] _ in
      guard let self = self else {
        return
      }
      if isMyProfile {
        self.getMyBookmarkedJournals()
      } else {
        self.getOthersBookmarkedJournals(userId: userId)
      }
    }.store(in: &subscription)
  }
  // MARK: Fetch Data

  /// Fetch Data를 하기 전 초기화
  func initData() {
    // travel journals
    bookmarkedJournals = []

    // flags for Infinite Scroll
    lastIdOfBookmarkedJournals = nil
    hasNextBookmarkedJournals = true
  }

  /// api를 통해 여행일지들을 가져옴
  /// 내 여행일지, 즐겨찾기된 여행일지, 테그된 여행일지 가져올 수 있음
  func fetchDataAsync() async {
    if isMyProfile {
      self.getMyBookmarkedJournals()
    } else {
      self.getOthersBookmarkedJournals(userId: userId)
    }
  }

  // MARK: Get Bookmarked Journals
  
  func updateBookmarkedJournals() {
    isBookmarkedJournalsLoading = false
    hasNextBookmarkedJournals = true
    lastIdOfBookmarkedJournals = nil
    bookmarkedJournals = []
    
    if isMyProfile {
      self.getMyBookmarkedJournals()
    } else {
      self.getOthersBookmarkedJournals(userId: userId)
    }
  }

  private func getMyBookmarkedJournals() {
    if isBookmarkedJournalsLoading || !hasNextBookmarkedJournals {
      return
    }

    self.isBookmarkedJournalsLoading = true
    journalProvider.requestPublisher(
      .getMyBookmarkedJournals(size: nil, lastId: self.lastIdOfBookmarkedJournals)
    )
    .sink { completion in
      switch completion {
      case .finished:
        self.isBookmarkedJournalsLoading = false
      case .failure(let error):
        self.isBookmarkedJournalsLoading = false

        guard let apiError = try? error.response?.map(ErrorData.self) else {
          // error data decoding error handling
          return
        }
        // other api error handling
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(BookmarkedJournalList.self)
        self.hasNextBookmarkedJournals = responseData.hasNext
        self.bookmarkedJournals += responseData.content
        self.lastIdOfBookmarkedJournals = responseData.content.last?.bookmarkId
      } catch {
        print("bookmarked journal list decoding error")
        return
      }
    }.store(in: &subscription)
  }
  
  private func getOthersBookmarkedJournals(userId: Int) {
    if isBookmarkedJournalsLoading || !hasNextBookmarkedJournals {
      return
    }

    self.isBookmarkedJournalsLoading = true
    journalProvider.requestPublisher(
      .getOthersBookmarkedJournals(userId: userId, size: nil, lastId: self.lastIdOfBookmarkedJournals)
    )
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
        // other api error handling
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(BookmarkedJournalList.self)
        self.hasNextBookmarkedJournals = responseData.hasNext
        self.bookmarkedJournals += responseData.content
        self.lastIdOfBookmarkedJournals = responseData.content.last?.bookmarkId
      } catch {
        print("bookmarked journal list decoding error")
        return
      }
    }.store(in: &subscription)
  }
}

