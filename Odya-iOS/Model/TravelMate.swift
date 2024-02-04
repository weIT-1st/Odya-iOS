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

extension TravelMate {
  func encodeToString() -> String {
    if let encodedData = try? JSONEncoder().encode(self) {
      return String(data: encodedData, encoding: .utf8) ?? ""
    }
    return ""
  }
}

extension String {
  func decodeToTravelMate() -> TravelMate? {
    if let data = self.data(using: .utf8),
       let decodedData = try? JSONDecoder().decode(TravelMate.self, from: data) {
      return decodedData
    }
    return nil
  }
}


struct travelMateSimple: Codable, Identifiable {
  var id = UUID()
  var username: String
  var profileUrl: String?
  
  private enum CodingKeys: String, CodingKey {
    case username, profileUrl
  }
}
