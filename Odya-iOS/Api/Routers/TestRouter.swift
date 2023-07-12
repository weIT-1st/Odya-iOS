//
//  TestRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/12.
//

import Foundation
import Alamofire

/// Test API 통신 라우터
enum TestRouter: URLRequestConvertible {
    
    case postUsername(username: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .postUsername:
            return "/test"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .postUsername(username):
            var params: Parameters = [
                "name" : username
            ]
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)
        request.method = method
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        
        return request
    }
}
