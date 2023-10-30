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
}

extension TopicRouter: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getTopicList:
            return "/api/v1/topics"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTopicList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTopicList:
            return .requestPlain
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
