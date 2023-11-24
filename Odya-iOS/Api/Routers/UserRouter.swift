//
//  UserRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation
import Moya

enum UserRouter {
  // 사용자 정보 조회
    case getUserInfo
  // 사용자 통계 조회
  case getUserStatistics(userId: Int)
  // 사용자 프로필 사진 변경
//  case updateUserProfileImage(profileImg)
}

extension UserRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .getUserInfo:
      return "/api/v1/users/me"
    case .getUserStatistics(let userId):
      return "/api/v1/users/\(userId)/statistics"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getUserInfo, .getUserStatistics:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
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
