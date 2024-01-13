//
//  FavoritePlaceInProfileViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class FavoritePlaceInProfileViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var placeProvider = MoyaProvider<FavoritePlaceRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

//  let isMyProfile: Bool
//  let userId: Int

  // loadingFlag
  var isFavoritePlacesLoading: Bool = false
  var isCounting: Bool = false

  // data
  @Published var favoritePlaces: [FavoritePlace] = []
  @Published var placesCount: Int = -1

  // MARK: Fetch Data

  /// Fetch Data를 하기 전 초기화
  func initData() {
    // place list
    isFavoritePlacesLoading = false
    favoritePlaces = []

    // count
    isCounting = false
  }

  /// api를 통해 관심장소 리스트, 관심 장소 수를 가져옴
  func fetchDataAsync(userId: Int) async {

//    if isMyProfile {
//      self.getMyFavoritePlaces()
//      self.getMyCount()
//    } else {
      self.getOthersFavoritePlaces(userId: userId)
      self.getOthersCount(userId: userId)
//    }

  }

  func updateFavoritePlaces(userId: Int) {
    initData()

//    if isMyProfile {
//      self.getMyFavoritePlaces()
//      self.getMyCount()
//    } else {
      self.getOthersFavoritePlaces(userId: userId)
      self.getOthersCount(userId: userId)
//    }
  }

  private func getMyFavoritePlaces() {
    if isFavoritePlacesLoading {
      return
    }

    self.isFavoritePlacesLoading = true
    placeProvider.requestPublisher(
      .getMyFavoritePlaces(size: 4, sortType: nil, lastId: nil)
    )
    .sink { completion in
      switch completion {
      case .finished:
        self.isFavoritePlacesLoading = false
      case .failure(let error):
        self.isFavoritePlacesLoading = false
        self.doErrorHandling(error)
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(FavoritePlacesResponse.self)
        self.favoritePlaces = responseData.content
      } catch {
        print("favorite place list decoding error")
        return
      }
    }.store(in: &subscription)
  }

  private func getOthersFavoritePlaces(userId: Int) {
    if isFavoritePlacesLoading {
      return
    }

    self.isFavoritePlacesLoading = true
    placeProvider.requestPublisher(
      .getOthersFavoritePlaces(userId: userId, size: 4, sortType: nil, lastId: nil)
    )
    .sink { completion in
      switch completion {
      case .finished:
        self.isFavoritePlacesLoading = false
      case .failure(let error):
        self.isFavoritePlacesLoading = false
        self.doErrorHandling(error)
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(FavoritePlacesResponse.self)
        self.favoritePlaces = responseData.content
      } catch {
        print("favorite place list decoding error")
        return
      }
    }.store(in: &subscription)
  }

  // MARK: count
  func getCount(userId: Int) {
//    if isMyProfile {
//      getMyCount()
//    } else {
      getOthersCount(userId: userId)
//      print("do getOthersCount()")
//    }
  }

  private func getMyCount() {
    if isCounting {
      return
    }

    isCounting = true
    placeProvider.requestPublisher(.getMyFavoritePlacesCount)
      .sink { completion in
        switch completion {
        case .finished:
          self.isCounting = false
        case .failure(let error):
          self.isCounting = false
          self.doErrorHandling(error)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(Int.self)
          self.placesCount = responseData
        } catch {
          print("favorite place count decoding error")
          return
        }
      }.store(in: &subscription)
  }

  private func getOthersCount(userId: Int) {
    if isCounting {
      return
    }

    isCounting = true
    placeProvider.requestPublisher(.getOthersFavoritePlacesCount(userId: userId))
      .sink { completion in
        switch completion {
        case .finished:
          self.isCounting = false
        case .failure(let error):
          self.isCounting = false
          self.doErrorHandling(error)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(Int.self)
          self.placesCount = responseData
        } catch {
          print("favorite place count decoding error")
          return
        }
      }.store(in: &subscription)
  }

  // MARK: Error Handling
  private func doErrorHandling(_ error: MoyaError) {
    guard let apiError = try? error.response?.map(ErrorData.self) else {
      // error data decoding error handling
      // unknown error
      print(error.localizedDescription)
      return
    }
    // api error handling
    print(apiError.message)
  }

}
