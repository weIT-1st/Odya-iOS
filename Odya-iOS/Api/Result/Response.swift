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
