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
  private lazy var bookmarkedJournalProvider = MoyaProvider<TravelJournalBookmarkRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private lazy var mainJournalProvider = MoyaProvider<MainTravelJournalRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()


  // loadingFlag
  var isMainJournalsLoading: Bool = false
  var isBookmarkedJournalsLoading: Bool = false
  var isCreatingMainJournal: Bool = false
  var isDeletingMainJournal: Bool = false

  // travel journals
  @Published var mainJournals: [MainJournalData] = []
  @Published var bookmarkedJournals: [BookmarkedJournalData] = []

  // flags for Infinite Scroll
  @Published var lastIdOfBookmarkedJournals: Int? = nil
  var hasNextBookmarkedJournals: Bool = true
  var fetchMoreSubject = PassthroughSubject<(Int), Never>()

  init() {
    fetchMoreSubject.sink { [weak self] userId in
      guard let self = self else {
        return
      }
        self.getBookmarkedJournalsByUserId(userId: userId)
    }.store(in: &subscription)
  }
  
  // MARK: Fetch Data

  /// Fetch Data를 하기 전 초기화
  func initData() {
    // travel journals
    mainJournals = []
    bookmarkedJournals = []

    // flags for Infinite Scroll
    lastIdOfBookmarkedJournals = nil
    hasNextBookmarkedJournals = true
  }

  /// api를 통해 여행일지들을 가져옴
  /// 내 여행일지, 즐겨찾기된 여행일지, 테그된 여행일지 가져올 수 있음
  func fetchDataAsync(userId: Int) {
    self.getBookmarkedJournalsByUserId(userId: userId)
    self.getMainJournalsByUserId(userId: userId)
  }

  // MARK: Get Bookmarked Journals

  func updateBookmarkedJournals(userId: Int) {
    isBookmarkedJournalsLoading = false
    hasNextBookmarkedJournals = true
    lastIdOfBookmarkedJournals = nil
    bookmarkedJournals = []
    
    self.getBookmarkedJournalsByUserId(userId: userId)
  }

  private func getBookmarkedJournalsByUserId(userId: Int) {
    if isBookmarkedJournalsLoading || !hasNextBookmarkedJournals {
      return
    }

    self.isBookmarkedJournalsLoading = true
    bookmarkedJournalProvider.requestPublisher(
      .getOthersBookmarkedJournals(
        userId: userId, size: nil, lastId: self.lastIdOfBookmarkedJournals)
    )
    .sink { completion in
      switch completion {
      case .finished:
        self.isBookmarkedJournalsLoading = false
      case .failure(let error):
        self.isBookmarkedJournalsLoading = false
        self.processErrorResponse(error)
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
  
  // MARK: Get Main Journals
  
  func updateMainJournals(userId: Int) {
    isMainJournalsLoading = false
    mainJournals = []
    
    self.getMainJournalsByUserId(userId: userId)
  }
  
  private func getMainJournalsByUserId(userId: Int) {
    if isMainJournalsLoading {
      return
    }
    
//    deleteMainJournal(journalId: 263) { _ in }

    self.isMainJournalsLoading = true
    mainJournalProvider.requestPublisher(
      .getOthersMainJournals(
        userId: userId, size: nil, lastId: nil)
    )
    .sink { completion in
      switch completion {
      case .finished:
        self.isMainJournalsLoading = false
      case .failure(let error):
        self.isMainJournalsLoading = false
        self.processErrorResponse(error)
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(MainJournalList.self)
        self.mainJournals = responseData.content
      } catch {
        print("main journal list decoding error")
        return
      }
    }.store(in: &subscription)
  }
  
  // MARK: Set Main Journal
  func setMainJournal(orgMainJournalId: Int?,
                      journalId: Int?,
                      completion: @escaping () -> Void) {
    
    if let newId = journalId {
      createMainJournal(journalId: newId) { success in
        if success {
          completion()
          if let orgId = orgMainJournalId {
            self.deleteMainJournal(journalId: orgId) { _ in }
          }
        }
      }
    } else {
      if let orgId = orgMainJournalId {
        self.deleteMainJournal(journalId: orgId) { success in
          completion()
        }
      }
    }
  }
  
  private func createMainJournal(journalId: Int,
                                 completion: @escaping (Bool) -> Void) {
    if isCreatingMainJournal {
      return
    }
    
    isCreatingMainJournal = true
    mainJournalProvider.requestPublisher(.createMainJournal(journalId: journalId))
      .sink { apiCompletion in
        self.isCreatingMainJournal = false
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  private func deleteMainJournal(journalId: Int,
                                 completion: @escaping (Bool) -> Void) {
    if isDeletingMainJournal {
      return
    }
    
    isDeletingMainJournal = true
    mainJournalProvider.requestPublisher(.deleteMainJournal(journalId: journalId))
      .sink { apiCompletion in
        self.isDeletingMainJournal = false
        switch apiCompletion {
        case .finished:
          completion(true)
        case .failure(let error):
          self.processErrorResponse(error)
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in journals in profile view model - \(errorData.message)")
    } else {  // unknown error
      print("in journals in profile view model - \(error)")
    }
  }
}
