//
//  SearchedUser.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/29.
//

import Foundation

// MARK: - SearchedUser
struct SearchedUser: Codable {
  let hasNext: Bool
  let content: [SearchedUserContent]
}

// MARK: - Content
struct SearchedUserContent: Codable, Equatable {
  let userId: Int
  let nickname: String
  let profile: ProfileData
  let isFollowing: Bool
  
  enum CodingKeys: String, CodingKey {
    case userId = "userId"
    case nickname, profile, isFollowing
  }
  
  static func == (lhs: SearchedUserContent, rhs: SearchedUserContent) -> Bool {
    return lhs.userId == rhs.userId
  }
}
