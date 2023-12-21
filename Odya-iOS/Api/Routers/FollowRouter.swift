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
  case create(followingID: Int)
  // 언팔로우
  case delete(followingID: Int)
  // 팔로워 팔로잉 수 가져오기
  case count(userID: Int)
  // 팔로잉 리스트 가져오기
  case getFollowing(
    userID: Int,
    page: Int,
    size: Int,
    sortType: FollowSortingType)
  // 팔로워 리스트 가져오기
  case getFollower(
    userID: Int,
    page: Int,
    size: Int,
    sortType: FollowSortingType)
  // 닉네임으로 팔로잉 친구 찾기
  case searchFollowingByNickname(
    size: Int? = nil,
    nickname: String,
    lastID: Int? = nil)
  // 닉네임으로 팔로워 친구 찾기
  case searchFollowerByNickname(
    size: Int? = nil,
    nickname: String,
    lastID: Int? = nil)
  // 알 수도 있는 친구
  case suggestUser(
    size: Int,
    lastID: Int? = nil)
  // 해당 장소에 방문한 친구 가져오기
  case getVisitingUser(placeID: String)
}

extension FollowRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .create, .delete:
      return "/api/v1/follows"
    case let .count(userID):
      return "/api/v1/follows/\(userID)/counts"
    case let .getFollowing(userID, _, _, _):
      return "/api/v1/follows/\(userID)/followings"
    case let .getFollower(userID, _, _, _):
      return "/api/v1/follows/\(userID)/followers"
    case .searchFollowingByNickname:
      return "/api/v1/follows/followings/search"
    case .searchFollowerByNickname:
      return "/api/v1/follows/followiers/search"
    case .suggestUser:
      return "/api/v1/follows/may-know"
    case let .getVisitingUser(placeID):
      return "/api/v1/follows/" + placeID
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
    case let .create(followingID),
      let .delete(followingID):
      let params = ["followingId": followingID]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    case let .getFollowing(_, page, size, sortType),
      let .getFollower(_, page, size, sortType):
      let params: [String: Any] = [
        "page": page,
        "size": size,
        "sortType": sortType.toString(),
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .searchFollowingByNickname(size, nickname, lastID),
      let .searchFollowerByNickname(size, nickname, lastID):
      var params: [String: Any] = [:]
      if let size = size {
        params["size"] = size
      }
      params["nickname"] = nickname
      if let lastId = lastID {
        params["lastId"] = lastId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .suggestUser(size, lastID):
      var params: [String: Any] = [:]
      params["size"] = size
      if let lastId = lastID {
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
