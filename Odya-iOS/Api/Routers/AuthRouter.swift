//
//  AuthRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Alamofire

// 인증 라우터
// 회원가입(애플, 카카오)
enum AuthRouter: URLRequestConvertible {
    case kakaoRegister(username: String,
                       email: String?,
                       phoneNumber: String?,
                       nickname: String,
                       gender: String,
                       birthday: [Int])
//    case appleRegister(idToken: String,
//                       email: String?,
//                       nickname: String,
//                       phoneNumber: String?,
//                       gender: String,
//                       birthday: [Int])
    
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .kakaoRegister:
            return "/api/v1/auth/register/kakao"
//        case .appleRegister:
//            return "/api/v1/auth/register/apple"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .kakaoRegister(username, email, phoneNumber, nickname, gender, birthday):
            var params = Parameters()
            params["username"] = username
            params["email"] = email
            params["phoneNumber"] = phoneNumber
            params["nickname"] = nickname
            params["gender"] = gender
            params["birthday"] = birthday
            return params
            
            //        case let .appleRegister(username, email, phoneNumber, nickname, gender, birthday):
            //            var params = Parameters()
            //            params["username"] = username
            //            params["email"] = email
            //            params["phoneNumber"] = phoneNumber
            //            params["nickname"] = nickname
            //            params["gender"] = gender
            //            params["birthday"] = birthday
            //            return params
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
