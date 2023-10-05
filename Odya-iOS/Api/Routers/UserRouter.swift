//
//  UserRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation
import Moya

enum UserRouter {
    case getUserInfo(token: String)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "/api/v1/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
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
        case let .getUserInfo(token):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
