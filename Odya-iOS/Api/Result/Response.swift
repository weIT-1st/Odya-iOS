//
//  Response.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation

// 디코딩 가능한 빈 Response
struct EmptyResponse: Codable {}

/**
 테스트 API를 통해 이름을 전달한 뒤, 해시값과 이름을 받아 저장하는 모델
 - id: Hash Value
 - name: Original Name
 */
struct TestNetworkResponse: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "hashValue"
        case name = "originalName"
    }
}

/// 카카오 로그인 성공 시 response
struct KakaoTokenResponse: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "firebaseCustomToken"
    }
}

/// 한줄리뷰 response
// MARK: - Review
struct Review: Codable {
    let hasNext: Bool
    let averageRating: Int
    let content: [ReviewContent]
}

// MARK: - Content
struct ReviewContent: Codable {
    let id: Int
    let placeID: String
    let userID: Int
    let writerNickname: String
    let starRating: Int
    let review: String

    enum CodingKeys: String, CodingKey {
        case id
        case placeID = "placeId"
        case userID = "userId"
        case writerNickname, starRating, review
    }
}
