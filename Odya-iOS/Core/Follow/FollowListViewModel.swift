//
//  FollowListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import SwiftUI

class FollowListViewModel: ObservableObject {
    let userID: String
    @Published var followingUsers: [FollowUserData] = []
    @Published var followerUsers: [FollowUserData] = []
    @Published var displayedUsers: [FollowUser] = []
    
    init(userID: String) {
        self.userID = userID
        for i in 0...50 {
            let userA = FollowUserData(
                userId: i, nickname: "홍길동aa\(i)",
                profileData: ProfileData(profileColor: ProfileColorData(colorHex: "#FFD41F")))
            followingUsers.append(userA)
            let userB = FollowUserData(
                userId: i, nickname: "홍길동bb\(i)",
                profileData: ProfileData(profileColor: ProfileColorData(colorHex: "#FFD41F")))
            followerUsers.append(userB)
        }
    }
    
    func setDisplayedUsers(followType: FollowType) {
        displayedUsers = []
        switch followType {
        case .following:
            for user in followingUsers {
                displayedUsers.append(FollowUser(userData: user, followType: .following, followState: true))
            }
        case .follower:
            for user in followerUsers {
                displayedUsers.append(FollowUser(userData: user, followType: .follower, followState: true))
            }
        }
    }
    
//    func tapFollowButton(user: FollowUser) {
//        user.followState.toggle()
//    }
    
}
