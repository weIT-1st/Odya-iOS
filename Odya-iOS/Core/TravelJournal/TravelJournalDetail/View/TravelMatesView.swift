//
//  TravelMatesView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/02.
//

import SwiftUI

private struct MateRowView: View {
  let mate: TravelMate

  var body: some View {
    HStack(spacing: 0) {
      ProfileImageView(profileUrl: mate.profileUrl ?? "", size: .S)
        .padding(.trailing, 12)

      Text(mate.nickname ?? "No Nickname")
        .foregroundColor(.odya.label.normal)
        .b1Style()
        .padding(.trailing, 4)
      Image("sparkle-s")

      Spacer()

      FollowButton(isFollowing: true, buttonStyle: .solid) {}
    }
  }
}

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
            NavigationLink(
              destination: UserProfileView(
                userId: mate.userId ?? -1, nickname: mate.nickname ?? "No Nickname")
            ) {
              MateRowView(mate: mate)
            }
          }
        }
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, GridLayout.side)

  }
}

struct TravelMatesView_Previews: PreviewProvider {

  static var previews: some View {
    TravelMatesView(
      mates: [
        TravelMate(userId: 1, nickname: "홍길동aa1", profileUrl: "", isRegistered: true),
        TravelMate(userId: 2, nickname: "홍길동aa2", profileUrl: "", isRegistered: true),
        TravelMate(userId: 3, nickname: "홍길동aa3", profileUrl: "", isRegistered: true),
        TravelMate(userId: 4, nickname: "홍길동aa4", profileUrl: "", isRegistered: true),
        TravelMate(userId: 5, nickname: "홍길동aa5", profileUrl: "", isRegistered: true),
      ]
    )

  }
}
