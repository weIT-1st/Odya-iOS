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
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()
  
  @AppStorage("WeITAuthToken") var idToken: String?
  
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
    guard let idToken = idToken else {
      return
    }
    
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    journalProvider.requestPublisher(.createBookmark(token: idToken, journalId: journalId))
      .filterSuccessfulStatusCodes()
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isStateUpdating = false
          completion(true)
        case .failure(let error):
          self.isStateUpdating = false

          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            print("createBookmark - ErrorData decoding error")
            completion(false)
            return
          }

          if apiError.code == -11000 {
            self.appDataManager.refreshToken { success in
              // token error handling
              if success {
                self.createBookmark(of: journalId) { _ in }
                return
              }
            }
          }
          
          // other api error handling
          print("createBookmark - something error")
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  private func deleteBookmark(of journalId: Int,
                      completion: @escaping (Bool) -> Void) {
    guard let idToken = idToken else {
      return
    }
    
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    journalProvider.requestPublisher(.deleteBookmark(token: idToken, journalId: journalId))
      .filterSuccessfulStatusCodes()
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isStateUpdating = false
          completion(true)
        case .failure(let error):
          self.isStateUpdating = false

          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            print("deleteBookmark - ErrorData decoding error")
            completion(false)
            return
          }

          if apiError.code == -11000 {
            self.appDataManager.refreshToken { success in
              // token error handling
              if success {
                self.deleteBookmark(of: journalId) { _ in }
                return
              }
            }
          }
          
          // other api error handling
          print("deleteBookmark - something error")
          completion(false)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
}
