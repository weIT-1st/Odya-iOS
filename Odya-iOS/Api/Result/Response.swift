//
//  Response.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation

// 디코딩 가능한 빈 Response
struct EmptyResponse: Codable {}

/// 카카오 로그인 성공 시 response
struct KakaoTokenResponse: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "firebaseCustomToken"
    }
}


