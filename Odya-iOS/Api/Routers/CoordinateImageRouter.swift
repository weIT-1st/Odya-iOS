//
//  CoordinateImageRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/26.
//

import Foundation
import Moya

enum CoordinateImageRouter {
  // 좌표 사진 조회
  case getCoordinateImages(leftLongitude: Double,
                           bottomLatitude: Double,
                           rightLongitude: Double,
                           topLatitude: Double,
                           size: Int?)
}

extension CoordinateImageRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .getCoordinateImages:
      return "/api/v1/images/coordinate"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    switch self {
    case let .getCoordinateImages(leftLongitude, bottomLatitude, rightLongitude, topLatitude, size):
      var params: [String: Any] = [:]
      params["leftLongitude"] = leftLongitude
      params["bottomLatitude"] = bottomLatitude
      params["rightLongitude"] = rightLongitude
      params["topLatitude"] = topLatitude
      params["size"] = size
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
  
  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }
  
  var validationType: ValidationType {
    return .successCodes
  }
}
