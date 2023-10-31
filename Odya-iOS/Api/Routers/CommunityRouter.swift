//
//  CommunityRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/05.
//

import Foundation
import Moya

enum CommunityRouter {
  // 1. 생성
  // 2. 상세 조회
  case getCommunityDetail(communityId: Int)
  // 3. 전체 목록 조회
  case getAllCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 4. 나의 목록 조회
  case getMyCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 5. 친구 목록 조회
  case getFriendsCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 6. 수정
  // 7. 삭제
  case deleteCommunity(communityId: Int)
}

extension CommunityRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .getCommunityDetail(let communityId):
      return "/api/v1/communities/\(communityId)"
    case .getAllCommunity:
      return "/api/v1/communities"
    case .getMyCommunity:
      return "/api/v1/communities/me"
    case .getFriendsCommunity:
      return "/api/v1/communities/friends"
    case .deleteCommunity(let communityId):
      return "/api/v1/communities/\(communityId)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getCommunityDetail, .getAllCommunity, .getMyCommunity, .getFriendsCommunity:
      return .get
    case .deleteCommunity:
      return .delete
    }
  }

  var task: Moya.Task {
    switch self {
    case .getCommunityDetail:
      return .requestPlain
    case .getAllCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .getMyCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .getFriendsCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .deleteCommunity:
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
