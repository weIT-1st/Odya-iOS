//
//  FavoritePlaceRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import Foundation
import Moya

enum PlaceSortType: String {
  case latest = "LATEST"
}

enum FavoritePlaceRouter {
  // 4. 관심 장소 수 조회
  case getFavoritePlacesCount
  // 5. 관심 장소 리스트 조회
  case getMyFavoritePlaces(size: Int?, sortType: PlaceSortType?, lastId: Int?)
  // 6. 타인의 관심 장소 리스트 조회
  case getOthersFavoritePlaces(userId: Int, size: Int?, sortType: PlaceSortType?, lastId: Int?)
}

extension FavoritePlaceRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .getFavoritePlacesCount:
      return "/api/v1/favorite-places/counts"
    case .getMyFavoritePlaces:
      return "/api/v1/favorite-places/list"
    case let .getOthersFavoritePlaces(userId, _, _, _):
      return "/api/v1/favorite-places/list/\(userId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .getMyFavoritePlaces(size, sortType, lastId),
      let .getOthersFavoritePlaces(_, size, sortType, lastId):
      var params: [String: Any] = [:]
      params["size"] = size
      params["sortType"] = sortType
      params["lastId"] = lastId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    default:
      return .requestPlain
    }
  }
  
  var headers: [String: String]? {
    switch self {
    default:
      return ["Content-type": "application/json"]
    }
  }

  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }

  var validationType: ValidationType {
    return .successCodes
  }
  
}

