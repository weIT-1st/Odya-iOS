//
//  CommunityComment.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/14.
//

import Foundation

// MARK: - Comment
struct Comment: Codable {
  let hasNext: Bool
  let content: [CommentContent]
}

// MARK: - Content
struct CommentContent: Codable {
  let communityCommentID: Int
  let content, updatedAt: String
  let isWriter: Bool
  let user: Writer

  enum CodingKeys: String, CodingKey {
    case communityCommentID = "communityCommentId"
    case content, updatedAt, isWriter, user
  }
}
