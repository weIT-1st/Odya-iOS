//
//  ImageRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/24.
//

import Foundation
import Moya

/// 인생샷 api
enum ImageRouter {
  // 1. 유저 사진 조회
  case getImages(size: Int?, lastId: Int?)
  // 2. 인생샷 설정
  case registerPOTD(imageId: Int, placeName: String?)
  // 3. 인생샷 취소
  case deletePOTD(imageId: Int)
}

extension ImageRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .getImages:
      return "/api/v1/images"
    case let .registerPOTD(imageId, _),
      let .deletePOTD(imageId):
      return "/api/v1/images/\(imageId)/life-shot"
    }
  }

  var method: Moya.Method {
    switch self {
    case .registerPOTD:
      return .post
    case .deletePOTD:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case let .getImages(size, lastId):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .registerPOTD(_, placeName):
      let params: [String: Any] = ["placeName": placeName as Any]
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
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
