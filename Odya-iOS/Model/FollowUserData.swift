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

enum FollowType {
    case following
    case follower
}

struct FollowUser: Identifiable, Hashable {
    var id = UUID()
    var userData: FollowUserData
    var followType: FollowType
    var followState: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
//    init(userData: FollowUserData, followType: FollowType, followState: Bool) {
//        self.userData = userData
//        self.followType = followType
//        self.followState = followState
//    }
    
//    mutating func changeFollowState() {
//        self.followState.toggle()
//    }
}
