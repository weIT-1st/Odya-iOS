//
//  PlaceTagSearchViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import Foundation
import GooglePlaces

final class PlaceTagSearchViewModel: NSObject, ObservableObject {
  // MARK: - Properties
  
  /// 검색 자동완성 결과
  @Published var searchResults = [GMSAutocompletePrediction]()
  
  let placeClient = GMSPlacesClient()
  
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
        self.searchResults = results
      }
      
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }
}
