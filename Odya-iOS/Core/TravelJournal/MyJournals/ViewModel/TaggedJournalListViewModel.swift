//
//  TaggedJournalListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import SwiftUI
import Moya
import CombineMoya
import Combine

class TaggedJournalListViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var journalTagProvider = MoyaProvider<TravelJournalTagRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  @Published var taggedJournals: [TaggedJournalData] = []

  // loading flag
  var isTaggedJournalsLoading: Bool = false
  var isTravelMateDeleting: Bool = false
  
  // infinite Scroll
  @Published var lastIdOfTaggedJournals: Int? = nil
  var hasNextTaggedJournals: Bool = true
  var fetchMoreTaggedJournalsSubject = PassthroughSubject<(), Never>()
  
  init() {
    fetchDataAsync()
    
    fetchMoreTaggedJournalsSubject
      .sink { [weak self] _ in
        guard let self = self,
              !self.isTaggedJournalsLoading,
              self.hasNextTaggedJournals else {
          return
        }
        self.getTaggedJournals()
      }.store(in: &subscription)
  }
  
  func fetchDataAsync() {
    if isTaggedJournalsLoading
        || !hasNextTaggedJournals {
      return
    }

    getTaggedJournals()
  }
  
  func updateTaggedJournals() {
    isTaggedJournalsLoading = false
    hasNextTaggedJournals = true
    lastIdOfTaggedJournals = nil
    taggedJournals = []
    
    getTaggedJournals()
  }

  private func getTaggedJournals() {
    self.isTaggedJournalsLoading = true
    journalTagProvider.requestPublisher(.getTaggedJournals(size: nil, lastId: self.lastIdOfTaggedJournals))
    .sink { completion in
      switch completion {
      case .finished:
        self.isTaggedJournalsLoading = false
      case .failure(let error):
        self.isTaggedJournalsLoading = false
        self.processErrorResponse(error)
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

  // MARK: Delete Tag
  func deleteTagging(of journalId: Int, completion: @escaping (Bool) -> Void) {
    if isTravelMateDeleting {
      return
    }
    
    isTravelMateDeleting = true
    journalTagProvider.requestPublisher(.deleteTravelMates(journalId: journalId))
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        self.isTravelMateDeleting = false
        completion(true)
      case .failure(let error):
        self.isTravelMateDeleting = false
        self.processErrorResponse(error)
        completion(false)
      }
    } receiveValue: { _ in }
    .store(in: &subscription)
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
