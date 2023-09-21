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
    case create(token: String, followingID: Int)
    case delete(token: String, followingID: Int)
    case count(token: String, userID: Int)
    case getFollowing(token: String,
                      userID: Int,
                      page: Int,
                      size: Int,
                      sortType: FollowSortingType)
    case getFollower(token: String,
                     userID: Int,
                     page: Int,
                     size: Int,
                     sortType: FollowSortingType)
    case searchFollowingByNickname(token: String,
                                   size: Int,
                                   nickname: String,
                                   lastID: Int)
    case suggestUser(token: String,
                     size: Int,
                     lastID: Int? = nil)
    case getVisitingUser(token: String,
                         placeID: String)
}

extension FollowRouter: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .create, .delete:
            return "/api/v1/follows"
        case let .count(_, userID):
            return  "/api/v1/follows/\(userID)/counts"
        case let .getFollowing(_, userID, _, _, _):
            return "/api/v1/follows/\(userID)/followings"
        case let .getFollower(_, userID, _, _, _):
            return "/api/v1/follows/\(userID)/followers"
        case let .searchFollowingByNickname(_, size, nickname, lastID):
            return "/api/v1/follows/followings/search?size=\(size)&nickname=\(nickname)&lastId=\(lastID)"
        case .suggestUser:
            return "/api/v1/follows/may-know"
        case let .getVisitingUser(_, placeID):
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
    
    var authorizationType: AuthorizationType? {
        switch self {
        default:
            return .bearer
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .create(token, _),
            let .delete(token, _),
            let .count(token, _),
            let .getFollowing(token, _, _, _, _),
            let .getFollower(token, _, _, _, _),
            let .searchFollowingByNickname(token, _, _, _),
            let .suggestUser(token, _, _),
            let .getVisitingUser(token, _):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .create(_, followingID),
            let .delete(_, followingID):
            let params = ["followingId" : followingID]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .getFollowing(_, _, page, size, sortType),
            let .getFollower(_, _, page, size, sortType):
            let params: [String: Any] = [
                "page": page,
                "size": size,
                "sortType": sortType.toString()
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .suggestUser(_, size, lastID):
            var params: [String: Any] = [:]
            params["size"] = size
            if let lastId = lastID {
                params["lastId"] = lastID
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
}
