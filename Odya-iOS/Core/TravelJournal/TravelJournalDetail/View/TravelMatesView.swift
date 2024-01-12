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

//// MARK: Preview
//struct TravelMatesView_Previews: PreviewProvider {
//
//  static var previews: some View {
//    TravelMatesView(
//      mates: [
//        TravelMate(
//          userId: 1, nickname: "홍길동aa1", profileUrl: "", isRegistered: true, isFollowing: true),
//        TravelMate(
//          userId: 2, nickname: "홍길동aa2", profileUrl: "", isRegistered: true, isFollowing: true),
//        TravelMate(
//          userId: 3, nickname: "홍길동aa3", profileUrl: "", isRegistered: true, isFollowing: true),
//        TravelMate(
//          userId: 4, nickname: "홍길동aa4", profileUrl: "", isRegistered: true, isFollowing: true),
//        TravelMate(
//          userId: 5, nickname: "홍길동aa5", profileUrl: "", isRegistered: true, isFollowing: true),
//      ]
//    )
//
//  }
//}
