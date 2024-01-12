//
//  LocationSearchViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import Combine
import GooglePlaces
import Moya
import SwiftUI

final class LocationSearchViewModel: NSObject, ObservableObject {
  // MARK: - Properties
  
  // MARK: Search
  /// 검색 자동완성 결과
  @Published var searchResults = [GMSAutocompletePrediction]()
  /// 선택한 장소 좌표 저장
  @Published var selectedLocation: CLLocationCoordinate2D?
  /// 최근검색어 저장 배열, 값 변경시 UserDefaults 업데이트
  @Published var recentSearchTexts = SearchData.recentSearchText {
    didSet {
      SearchData.recentSearchText = recentSearchTexts
    }
  }
  /// 현재 검색 쿼리, 값 변경시 마다 검색 수행
  @Published var queryFragment: String = ""
  var debouncedQueryFragment: String = "" {
    didSet {
      locationSearch(query: debouncedQueryFragment)
    }
  }
  
  let placeClient = GMSPlacesClient()
  var placeToken = GMSAutocompleteSessionToken.init()
  
  // MARK: PlaceSearchHistory
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var historyProvider = MoyaProvider<PlaceSearchHistoryRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // MARK: - Init
  
  override init() {
    super.init()
    bind()
  }
  
  // MARK: - FUNCTIONS-Location Search
  
  /// 검색 문자열로 장소 검색
  func locationSearch(query: String) {
    /// 검색 자동완성 토큰
    placeToken = GMSAutocompleteSessionToken.init()
    
    searchResults = []
    placeClient.findAutocompletePredictions(fromQuery: query,
                                            filter: .none,
                                            sessionToken: placeToken) { results, error in
      if let results = results {
        self.searchResults = results
      }
      
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  
  
  // MARK: - FUNCTIONS-Update Recent Search Array
  
  /// 최근 검색어 배열에 검색어 추가
  func appendRecentSearch() {
    // 중복검사
    if recentSearchTexts.contains(queryFragment) {
      if let index = recentSearchTexts.firstIndex(of: queryFragment) {
        recentSearchTexts.append(recentSearchTexts.remove(at: index))
      }
    } else {
      recentSearchTexts.append(queryFragment)
    }
    // 최대 20개 제한
    limitNumberOfRecentSearch()
  }
  
  /// 최근 검색어 배열에서 검색어 삭제
  func removeRecentSearch(searchText: String) {
    if let index = recentSearchTexts.firstIndex(of: searchText) {
      recentSearchTexts.remove(at: index)
    }
  }
  
  /// 최대 20개까지의 최근 검색어 유지
  func limitNumberOfRecentSearch() {
    if recentSearchTexts.count > 20 {
      recentSearchTexts.removeFirst()
    }
  }
  
  /// 최근 검색어 모두 삭제
  func removeAllRecentSearch() {
    recentSearchTexts.removeAll()
  }
  
  // MARK: - FUNCTIONS-PlaceSearchHistory
  
  func savePlaceSearchHistory() {
    historyProvider.requestPublisher(.createPlaceSearchHistory(searchTerm: queryFragment))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("장소 검색어 저장 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData)
          }
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}

// MARK: - Extension: LocationSearchViewModel
extension LocationSearchViewModel {
  func bind() {
    $queryFragment
      .removeDuplicates()
      .debounce(for: 0.5, scheduler: DispatchQueue.main)
      .sink { value in
        self.debouncedQueryFragment = value
      }
      .store(in: &subscription)
  }
}
