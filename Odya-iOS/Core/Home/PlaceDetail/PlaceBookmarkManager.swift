//
//  PlaceBookmarkManager.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/25.
//

import Combine
import Moya
import SwiftUI

final class PlaceBookmarkManager: ObservableObject {
  // MARK: - Properties
  @AppStorage("WeITAuthToken") var idToken: String?
  // plugins
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  // providers
  private lazy var favoritePlaceProvider = MoyaProvider<FavoritePlaceRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  var subscription = Set<AnyCancellable>()
  
  var isStateUpdating: Bool = false
  var isBookmarked: Bool = false
  
  /// 관심 장소 여부 확인
  func checkIfFavoritePlace(placeId: String) {
    isStateUpdating = true
    favoritePlaceProvider.requestPublisher(.getIfMyFavoritePlace(placeId: placeId))
      .sink { completion in
        switch completion {
        case .finished:
          self.isStateUpdating = false
        case .failure(let error):
          self.isStateUpdating = false
          self.processErrorResponse(error)
        }
      } receiveValue: { response in
        
      }
      .store(in: &subscription)
  }
  
  /// PlaceId(String)만 사용해 북마크 상태 변경
  func setBookmarkStateWithPlacdId(_ isBookmarked: Bool, _ placeId: String,
                                   completion: @escaping (Bool) -> Void) {
    if isBookmarked {
      deleteBookmarkWithPlaceId(of: placeId) { success in
        completion(!success)
      }
    } else {
      createBookmark(of: placeId) { success in
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
  
  private func deleteBookmarkWithPlaceId(of placeId: String,
                                         completion: @escaping (Bool) -> Void) {
    if isStateUpdating {
      return
    }
    
    isStateUpdating = true
    favoritePlaceProvider.requestPublisher(.deleteFavoritePlaceByPlacdId(placeId: placeId))
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
      print("ERROR: In Place Detail Bookmark with \(errorData.message)")
    } else {  // unknown error
      print("ERROR: \(error.localizedDescription)")
    }
  }
}
