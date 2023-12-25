//
//  ReviewRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/22.
//

import Foundation
import Moya

// 한줄리뷰 라우터
// 한줄리뷰 CRUD
enum ReviewRouter {
  // 1. 장소리뷰 생셩
  case createReview(placeId: String, rating: Int, review: String)
  // 2. 장소리뷰 수정
  case updateReview(id: Int, rating: Int?, review: String?)
  // 3. 장소리뷰 삭제
  case deleteReview(reviewId: Int)
  // 4. 장소 ID 리뷰 조회
  case readPlaceIdReview(placeId: String, size: Int?, sortType: String?, lastId: Int?)
  // 5. 유저 ID 리뷰 조회
  case readUserIdReview(userId: Int, size: Int?, sortType: String?, lastId: Int?)
}

extension ReviewRouter: TargetType, AccessTokenAuthorizable {
  
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case let .deleteReview(reviewId):
      return "/api/v1/place-reviews/" + "\(reviewId)"
    case let .readPlaceIdReview(placeId, _, _, _):
      return "/api/v1/place-reviews/places/" + "\(placeId)"
    case let .readUserIdReview(userId, _, _, _):
      return "/api/v1/place-reviews/users/" + "\(userId)"
    default:
      return "/api/v1/place-reviews"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createReview:
      return .post
    case .updateReview:
      return .patch
    case .deleteReview:
      return .delete
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .createReview(placeId, rating, review):
      var params: [String: Any] = [:]
      params["placeId"] = placeId
      params["rating"] = rating
      params["review"] = review
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    case let .updateReview(id, rating, review):
      var params: [String: Any] = [:]
      params["id"] = id
      params["rating"] = rating
      params["review"] = review
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    case let .readPlaceIdReview(_, size, sortType, lastId),
      let .readUserIdReview(_, size, sortType, lastId):
      var params: [String: Any] = [:]
      if let size = size {
        params["size"] = size
      }
      if let sortType = sortType {
        params["sortType"] = sortType
      }
      if let lastId = lastId {
        params["lastId"] = lastId
      }
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
