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
struct Review: Codable, Identifiable {
  var id = UUID()
  var reviewId: Int
  var placeId: String
  var writer: Writer
  var starRating: Int
  var review: String
  var createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case reviewId = "id"
    case placeId
    case writer = "userInfo"
    case starRating, review, createdAt
  }
}