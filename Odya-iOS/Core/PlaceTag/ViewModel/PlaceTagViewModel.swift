//
//  PlaceTagViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import Combine
import Foundation
import GoogleMaps
import GooglePlaces

final class PlaceTagViewModel: NSObject, ObservableObject {
  // MARK: - Properties
  
  /// 검색 자동완성 결과
  @Published var searchResults = [GMSAutocompletePrediction]()
  @Published var markers: [GMSMarker] = []
  @Published var selectedMarker: GMSMarker? = nil
  @Published var bounds = GMSCoordinateBounds()
  
  let placeClient = GMSPlacesClient()
  
  var coordinateDict: [String: CLLocationCoordinate2D] = [:]
  private var subscription = Set<AnyCancellable>()
  
  override init() {
    super.init()
    bind()
  }
  
  // MARK: - Helper functions
  
  /// 검색 문자열로 장소 검색
  func searchPlace(query: String) {
    // 검색 자동완성 토큰
    let token = GMSAutocompleteSessionToken.init()
    
    searchResults = []
    placeClient.findAutocompletePredictions(fromQuery: query,
                                            filter: .none,
                                            sessionToken: token) { results, error in
      if let results = results {
        self.markers = []
        self.coordinateDict = [:]
        self.selectedMarker = nil
        self.searchResults = results
      }
      
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  /// PlaceId로 좌표 찾기
  func getCoordinateFromPlaceId(placeId: String) {
    placeClient.lookUpPlaceID(placeId) { place, error in
      if let error = error {
        print("장소 좌표를 찾을 수 없음 \(error.localizedDescription)")
        return
      }
      
      guard let place = place else {
        print("장소 정보 존재하지 않음 \(placeId)")
        return
      }
      
      self.coordinateDict[placeId] = place.coordinate
      self.markers.append(GMSMarker(position: place.coordinate))
      self.bounds = self.bounds.includingCoordinate(place.coordinate)
    }
  }
  
  /// 장소 선택
  func selectPlace(placeId: String) {
    if let coordinate = coordinateDict[placeId] {
      self.selectedMarker = markers.filter {
        $0.position.latitude == coordinate.latitude && $0.position.longitude == coordinate.longitude
      }.first
    }
  }
  
  func bind() {
    $searchResults
      .sink { value in
        value.forEach { self.getCoordinateFromPlaceId(placeId: $0.placeID) }
      }
      .store(in: &subscription)
  }
}
