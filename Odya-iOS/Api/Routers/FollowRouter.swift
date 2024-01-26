//
//  FollowRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/16.
//

import Foundation
import Moya

enum FollowSortingType {
  case oldest
  case latest

  func toString() -> String {
    switch self {
    case .latest:
      return "LATEST"
    case .oldest:
      return "OLDEST"
    }
  }
}

enum FollowRouter {
  // 팔로우 실행
  case create(followingId: Int)
  // 언팔로우
  case delete(followingId: Int)
  // 팔로워 팔로잉 수 가져오기
  case count(userId: Int)
  // 팔로잉 리스트 가져오기
  case getFollowing(
    userId: Int,
    page: Int,
    size: Int,
    sortType: FollowSortingType)
  // 팔로워 리스트 가져오기
  case getFollower(
    userId: Int,
    page: Int,
    size: Int,
    sortType: FollowSortingType)
  // 닉네임으로 팔로잉 친구 찾기
  case searchFollowingByNickname(
    userId: Int,
    size: Int? = nil,
    nickname: String,
    lastId: Int? = nil)
  // 닉네임으로 팔로워 친구 찾기
  case searchFollowerByNickname(
    userId: Int,
    size: Int? = nil,
    nickname: String,
    lastId: Int? = nil)
  // 알 수도 있는 친구
  case suggestUser(
    size: Int,
    lastId: Int? = nil)
  // 해당 장소에 방문한 친구 가져오기
  case getVisitingUser(placeId: String)
}

extension FollowRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .create, .delete:
      return "/api/v1/follows"
    case let .count(userId):
      return "/api/v1/follows/\(userId)/counts"
    case let .getFollowing(userId, _, _, _):
      return "/api/v1/follows/\(userId)/followings"
    case let .getFollower(userId, _, _, _):
      return "/api/v1/follows/\(userId)/followers"
    case let .searchFollowingByNickname(userId, _, _, _):
      return "/api/v1/follows/\(userId)/followings/search"
    case let .searchFollowerByNickname(userId, _, _, _):
      return "/api/v1/follows/\(userId)/followers/search"
    case .suggestUser:
      return "/api/v1/follows/may-know"
    case let .getVisitingUser(placeId):
      return "/api/v1/follows/" + placeId
    }
  }

  var method: Moya.Method {
    switch self {
    case .create:
      return .post
    case .delete:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case let .create(followingId),
      let .delete(followingId):
      let params = ["followingId": followingId]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    case let .getFollowing(_, page, size, sortType),
      let .getFollower(_, page, size, sortType):
      let params: [String: Any] = [
        "page": page,
        "size": size,
        "sortType": sortType.toString(),
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .searchFollowingByNickname(_, size, nickname, lastId),
      let .searchFollowerByNickname(_, size, nickname, lastId):
      var params: [String: Any] = [:]
      params["size"] = size
      params["nickname"] = nickname
      params["lastId"] = lastId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .suggestUser(size, lastId):
      var params: [String: Any] = [:]
      params["size"] = size
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
