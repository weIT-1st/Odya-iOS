//
//  TravelMatesView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/02.
//

import SwiftUI

// MARK: Travel Mates View
struct TravelMatesView: View {
  let mates: [TravelMate]

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("함께 간 친구")
          .h4Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 26)
        Spacer()
      }

      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 16) {
          ForEach(mates) { mate in
            if let userId = mate.userId,
              let nickname = mate.nickname,
              let profileUrl = mate.profileUrl
            {
              UserIdentityRowWithFollowing(
                userId: userId, nickname: nickname, profileUrl: profileUrl,
                isFollowing: mate.isFollowing)
            }
          }
        }
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, GridLayout.side)
  }
}


