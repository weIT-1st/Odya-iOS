//
//  Review.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/17.
//

import SwiftUI

/// 한줄리뷰 response
// MARK: - Review
struct ReviewListResponse: Codable {
    let hasNext: Bool
    let content: [Review]
}

// MARK: - Content
struct Review: Codable {
  let reviewId: Int
  let placeId: String
  let writer: Writer
  let starRating: Int
  let review: String
  let createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case reviewId = "id"
    case placeId
    case writer = "userInfo"
    case starRating, review, createdAt
  }
}
