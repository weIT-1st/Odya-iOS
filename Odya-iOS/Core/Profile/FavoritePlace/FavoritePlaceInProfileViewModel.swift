//
//  FavoritePlaceInProfileViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI
import Combine
import CombineMoya
import FirebaseAuth
import Moya

class FavoritePlaceInProfileViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var placeProvider = MoyaProvider<FavoritePlaceRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()
  
  // loadingFlag
  var isFavoritePlacesLoading: Bool = false
  var isCounting: Bool = false

  // data
  @Published var favoritePlaces: [FavoritePlace] = []
  @Published var placesCount: Int = 0
  
  // MARK: Fetch Data

  /// api를 통해 관심장소 리스트, 관심 장소 수를 가져옴
  func fetchDataAsync() async {
    isFavoritePlacesLoading = false
    favoritePlaces = []
    getFavoritePlaces()
    
    isCounting = false
    getCount()
  }

  private func getFavoritePlaces() {
    if isFavoritePlacesLoading {
      return
    }

    self.isFavoritePlacesLoading = true
    placeProvider.requestPublisher(
      .getFavoritePlaces(size: 4, sortType: nil, lastId: nil))
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
  
  private func getCount() {
    if isCounting {
      return
    }

    isCounting = true
    placeProvider.requestPublisher(.getFavoritePlacesCount)
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
