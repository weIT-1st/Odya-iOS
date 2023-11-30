//
//  TopicRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/31.
//

import Foundation
import Moya

enum TopicRouter {
  // 1. 토픽 리스트 조회
  case getTopicList
  // 2. 관심 토픽 등록
  case createMyTopic(idList: [Int])
  // 3. 관심 토픽 등록 해제
  case deleteMyTopic(id: Int)
  // 4. 관심 토픽 조회
  case getMyTopicList
}

extension TopicRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .getTopicList, .createMyTopic:
      return "/api/v1/topics"
    case .deleteMyTopic(let id):
      return "/api/v1/topics/\(id)"
    case .getMyTopicList:
      return "/api/v1/topics/favorite"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createMyTopic:
        return .post
    case .deleteMyTopic:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .createMyTopic(let idList):
      let params: [String : [Int]] = ["topicIdList" : idList]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
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
