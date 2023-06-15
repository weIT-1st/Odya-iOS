//
//  LocationSearchViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import Foundation
import GooglePlaces

class LocationSearchViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    
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
    @Published var queryFragment: String = "" {
        didSet {
            locationSearch(query: queryFragment)
        }
    }
    
    /// 검색 자동완성 토큰
    let token = GMSAutocompleteSessionToken.init()
    let placeClient = GMSPlacesClient()
    
    // MARK: - FUNCTIONS-Location Search
    
    /// 검색 문자열로 장소 검색
    func locationSearch(query: String) {
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
        // TODO: - detail 뷰로 토큰 전달
        /**
         * Create a new session token. Be sure to use the same token for calling
         * findAutocompletePredictions, as well as the subsequent place details request.
         * This ensures that the user's query and selection are billed as a single session.
         */
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
    }
    
    /// 최근 검색어 배열에서 검색어 삭제
    func removeRecentSearch(searchText: String) {
        if let index = recentSearchTexts.firstIndex(of: searchText) {
            recentSearchTexts.remove(at: index)
        }
    }

}
