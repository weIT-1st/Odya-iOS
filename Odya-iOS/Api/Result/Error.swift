//
//  Error.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation

enum MyError: Error {
  case unknown(String)
  case decodingError(String)
  case apiError(ErrorData)
  case tokenError
}

// 로그인 Error 타입 정의
enum APIError: Error {
    case http(ErrorData)
    case unauthorizedToken(KakaoLoginErrorResponse)
    case unknown
}

// ErrorData 안에 들어갈 정보 선언
struct ErrorData: Codable {
    var code: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "errorMessage"
    }
}

// 카카오 유효하지만 가입되지 않은 토큰 에러
struct KakaoLoginErrorUserData: Codable {
    var username: String
    var email: String?
    var phoneNumber: String?
    var nickname: String
    var gender: String?
}

struct KakaoLoginErrorResponse: Codable {
    var code: Int
    var message: String
    var data: KakaoLoginErrorUserData
    
    enum CodingKeys: String, CodingKey {
        case code, data
        case message = "errorMessage"
    }
}

