//
//  TravelMate.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/04.
//

import SwiftUI

struct TravelMate: Codable, Identifiable {
  var id = UUID()
  var userId: Int?
  var nickname: String?
  var profileUrl: String?
  var profileColor: ProfileColorData? = nil
  var isRegistered: Bool
  var isFollowing: Bool
  
  private enum CodingKeys: String, CodingKey {
    case userId, nickname, profileUrl, isRegistered, isFollowing
  }
  
  init(userId: Int, nickname: String, profile: ProfileData, isFollowing: Bool) {
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profile.profileUrl
    self.profileColor = profile.profileColor
    self.isFollowing = isFollowing
    self.isRegistered = true
  }
}

extension TravelMate: Equatable {
    static func == (lhs: TravelMate, rhs: TravelMate) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    static func != (lhs: TravelMate, rhs: TravelMate) -> Bool {
        return !(lhs == rhs)
    }
}

struct travelMateSimple: Codable {
    var username: String
    var profileUrl: String?
}
