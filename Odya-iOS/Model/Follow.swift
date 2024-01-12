//
//  FollowUserData.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

enum FollowType {
  case following
  case follower
}

// MARK: Follow Count
struct FollowCount: Codable {
  var followingCount: Int = 0
  var followerCount: Int = 0
}

// MARK: fetch following/follwer users
struct FollowUserListResponse: Codable {
  var hasNext: Bool
  var content: [FollowUserData]
}

// MARK: Follow User Data
struct FollowUserData: Codable, Identifiable {
  var id = UUID()
  var userId: Int
  var nickname: String
  var profile: ProfileData
  var isFollowing: Bool

  private enum CodingKeys: String, CodingKey {
    case userId, nickname, profile, isFollowing
  }
}

extension FollowUserData: Equatable {
  static func == (lhs: FollowUserData, rhs: FollowUserData) -> Bool {
    return lhs.id == rhs.id
  }

  static func != (lhs: FollowUserData, rhs: FollowUserData) -> Bool {
    return !(lhs == rhs)
  }
}
