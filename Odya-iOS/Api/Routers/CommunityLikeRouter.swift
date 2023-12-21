//
//  CommunityLikeRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/17.
//

import Foundation
import Moya

enum CommunityLikeRouter {
  case createLike(communityId: Int)
  case deleteLike(communityId: Int)
}

extension CommunityLikeRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .createLike(let communityId):
      return "/api/v1/communities/\(communityId)/likes"
    case .deleteLike(let communityId):
      return "/api/v1/communities/\(communityId)/likes"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createLike:
      return .post
    case .deleteLike:
      return .delete
    }
  }

  var task: Moya.Task {
    return .requestPlain
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
