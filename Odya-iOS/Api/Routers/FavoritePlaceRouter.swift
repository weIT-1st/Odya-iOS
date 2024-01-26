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
  // 1. 관심 장소 등록
  case createFavoritePlace(placeId: String)
  // 2. 관심 장소 삭제
  case deleteFavoritePlace(id: Int)
  // 3. 관심 장소 삭제
  case deleteFavoritePlaceByPlacdId(placeId: String)
  // 4. 관심 장소 수 조회
  case getMyFavoritePlacesCount
  // 5. 타인의 관심 장소 수 조회
  case getOthersFavoritePlacesCount(userId: Int)
  // 6. 관심 장소 리스트 조회
  case getMyFavoritePlaces(size: Int?, sortType: PlaceSortType?, lastId: Int?)
  // 7. 타인의 관심 장소 리스트 조회
  case getOthersFavoritePlaces(userId: Int, size: Int?, sortType: PlaceSortType?, lastId: Int?)
  // 8. 관심 장소 확인
  case getIfMyFavoritePlace(placeId: String)
}

extension FavoritePlaceRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .createFavoritePlace:
      return "/api/v1/favorite-places"
    case .deleteFavoritePlace(let id):
      return "/api/v1/favorite-places/\(id)"
    case .deleteFavoritePlaceByPlacdId(let placeId):
      return "/api/v1/favorite-places/places/\(placeId)"
    case .getMyFavoritePlacesCount:
      return "/api/v1/favorite-places/counts"
    case .getOthersFavoritePlacesCount(let userId):
      return "/api/v1/favorite-places/counts/\(userId)"
    case .getMyFavoritePlaces:
      return "/api/v1/favorite-places/list"
    case let .getOthersFavoritePlaces(userId, _, _, _):
      return "/api/v1/favorite-places/list/\(userId)"
    case .getIfMyFavoritePlace(let placeId):
      return "/api/v1/favorite-places/\(placeId)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createFavoritePlace:
      return .post
    case .deleteFavoritePlace, .deleteFavoritePlaceByPlacdId:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .createFavoritePlace(let placeId):
      var params: [String: Any] = [:]
      params["placeId"] = placeId
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
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
