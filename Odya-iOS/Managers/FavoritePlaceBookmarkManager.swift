//
//  FavoritePlaceBookmarkManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/11.
//

import SwiftUI
import Combine
import CombineMoya
import Moya

class FavoritePlaceBookmark: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var favoritePlaceProvider = MoyaProvider<FavoritePlaceRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // loading flag
  var isStateUpdating: Bool = false
  
  func setBookmarkState(_ isBookmarked: Bool, _ placeIdStr: String, _ placeId: Int,
                       completion: @escaping (Bool) -> Void) {
    if isBookmarked {
      deleteBookmark(of: placeId) { success in
        completion(!success)
      }
    } else {
      createBookmark(of: placeIdStr) { success in
        completion(success)
      }
    }
  }
  
  private func createBookmark(of placeIdStr: String,
                      completion: @escaping (Bool) -> Void) {
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    favoritePlaceProvider.requestPublisher(.createFavoritePlace(placeId: placeIdStr))
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
  
  private func deleteBookmark(of placeId: Int,
                      completion: @escaping (Bool) -> Void) {
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    favoritePlaceProvider.requestPublisher(.deleteFavoritePlace(id: placeId))
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
      print("in Favorite Place Bookmark Manager - \(errorData.message)")
    } else {  // unknown error
      print("in Favorite Place Bookmark Manager - \(error)")
    }
  }
  
}

