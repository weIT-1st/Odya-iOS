//
//  JournalBookmarkManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/19.
//

import SwiftUI
import Combine
import CombineMoya
import Moya

class JournalBookmarkManager: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var journalProvider = MoyaProvider<TravelJournalBookmarkRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // loading flag
  var isStateUpdating: Bool = false
  
  func setBookmarkState(_ isBookmarked: Bool, _ journalId: Int,
                       completion: @escaping (Bool) -> Void) {
    if isBookmarked {
      deleteBookmark(of: journalId) { success in
        completion(!success)
      }
    } else {
      createBookmark(of: journalId) { success in
        completion(success)
      }
    }
  }
  
  private func createBookmark(of journalId: Int,
                      completion: @escaping (Bool) -> Void) {
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    journalProvider.requestPublisher(.createBookmark(journalId: journalId))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isStateUpdating = false
          completion(true)
        case .failure(let error):
          self.isStateUpdating = false
          self.processErrorResponse(error)
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  private func deleteBookmark(of journalId: Int,
                      completion: @escaping (Bool) -> Void) {
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    journalProvider.requestPublisher(.deleteBookmark(journalId: journalId))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isStateUpdating = false
          completion(true)
        case .failure(let error):
          self.isStateUpdating = false
          self.processErrorResponse(error)
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in JournalBookmarkManager - \(errorData.message)")
    } else {  // unknown error
      print("in JournalBookmarkManager - \(error)")
    }
  }
  
}
