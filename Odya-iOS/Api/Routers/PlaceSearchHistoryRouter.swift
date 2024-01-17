//
//  PlaceSearchHistoryRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/29.
//

import Foundation
import Moya

enum PlaceSearchHistoryRouter {
  // 1. 장소 검색 기록 저장
  case createPlaceSearchHistory(searchTerm: String)
  // 2. 전체 검색 순위
  case getEntireRanking
  // 3. 나이대별 검색 순위
  case getRankingByAgeRange(ageRange: Int)
}

extension PlaceSearchHistoryRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .createPlaceSearchHistory:
      return "/api/v1/place-search-histories"
    case .getEntireRanking:
      return "/api/v1/place-search-histories/ranking"
    case .getRankingByAgeRange(let ageRange):
      return "/api/v1/place-search-histories/ranking/ageRange/\(ageRange)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createPlaceSearchHistory:
      return .post
    case .getEntireRanking, .getRankingByAgeRange:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .createPlaceSearchHistory(let searchTerm):
      var params: [String: Any] = [:]
      params["searchTerm"] = searchTerm
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    case .getEntireRanking:
      return .requestPlain
    case .getRankingByAgeRange:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }

  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }

  var validationType: ValidationType {
    return .successCodes
  }
}
