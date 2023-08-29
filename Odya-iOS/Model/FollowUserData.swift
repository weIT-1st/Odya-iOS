//
//  FollowUserData.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

struct ProfileColorData: Codable {
    var colorHex: String?
}

struct ProfileData: Codable {
    var profileUrl: String?
    var profileColor: ProfileColorData
}

struct FollowUserData: Codable, Identifiable, Hashable {
    var id = UUID()
    var userId: Int
    var nickname: String
    var profileData: ProfileData
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
