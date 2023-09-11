//
//  FollowButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/24.
//

import SwiftUI

extension View {
    func FollowButton(isFollowing: Bool, buttonStyle: ButtonStyleType,
                          action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(isFollowing ? "팔로잉" : "팔로우")
                .detail1Style()
                .padding(8)
        }.buttonStyle(CustomButtonStyle(cornerRadius: Radius.small, state: isFollowing ? .inactive : .active, style: buttonStyle))
    }
}

//struct FollowButton: View {
//    var isFollowing: Bool
//    var
//}
