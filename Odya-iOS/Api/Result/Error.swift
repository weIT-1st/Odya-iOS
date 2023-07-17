//
//  Error.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation

// 로그인 Error 타입 정의
enum APIError: Error {
    case http(ErrorData)
    case unauthorizedToken(KakaoLoginErrorResponse)
    case unknown
}

// 1. Error 타입 정의
//enum TestAPIError: Error {
//    case http(ErrorData)
//    case unknown
//}
 
// ErrorData 안에 들어갈 정보 선언
struct ErrorData: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "errorMessage"
    }
}

// 카카오 유효하지만 가입되지 않은 토큰 에러
struct KakaoLoginErrorResponse: Codable {
    var username: String
    var email: String?
    var phoneNumber: String?
    var nickname: String
    var gender: String?
}
