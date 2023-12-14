//
//  BookmarkedJournalListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import SwiftUI
import Moya
import CombineMoya
import Combine

class BookmarkedJournalListViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var journalBookmarkProvider = MoyaProvider<TravelJournalBookmarkRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  // MARK: Properties
  
  // data
  @Published var bookmarkedJournals: [BookmarkedJournalData] = []

  // loading flag
  @Published var isBookmarkedJournalsLoading: Bool = false
  
  // infinite scroll
  @Published var lastIdOfBookmarkedJournals: Int? = nil
  var hasNextBookmarkedJournals: Bool = true
  var fetchMoreBookmarkedJournalsSubject = PassthroughSubject<(), Never>()

  // MARK: Init
  
  init() {
    fetchDataAsync()
    
    fetchMoreBookmarkedJournalsSubject
      .sink { [weak self] _ in
        guard let self = self,
              !self.isBookmarkedJournalsLoading,
              self.hasNextBookmarkedJournals else {
          return
        }
        self.getBookmarkedJournals()
      }.store(in: &subscription)
  }

  // MARK: Get Bookmarked Journals

  func fetchDataAsync() {
    if isBookmarkedJournalsLoading
        || !hasNextBookmarkedJournals {
      return
    }

    getBookmarkedJournals()
  }

  func updateBookmarkedJournals() {
    isBookmarkedJournalsLoading = false
    hasNextBookmarkedJournals = true
    lastIdOfBookmarkedJournals = nil
    bookmarkedJournals = []

    getBookmarkedJournals()
  }

  private func getBookmarkedJournals() {
    self.isBookmarkedJournalsLoading = true
    journalBookmarkProvider.requestPublisher(.getBookmarkedJournals(size: nil, lastId: self.lastIdOfBookmarkedJournals))
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
        self.lastIdOfBookmarkedJournals = responseData.content.last?.bookmarkId ?? nil
      } catch {
        print("BookmarkedJournalList decoding error")
        return
      }
    }.store(in: &subscription)
  }

  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in profile view model - \(errorData.message)")
    } else {  // unknown error
      print("in profile view model - \(error)")
    }
  }
}
