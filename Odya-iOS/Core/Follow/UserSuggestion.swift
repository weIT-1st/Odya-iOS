//
//  UserSuggestion.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import SwiftUI

struct SuggestedUserView: View {
    private let suggestedUser: FollowUserData
    private let profileImageStatus: ProfileImageStatus
    
    @State var followState: Bool = false

    init(user: FollowUserData) {
      self.suggestedUser = user
      if let profileUrl = user.profileData.profileUrl {
        self.profileImageStatus = .withImage(url: URL(string: profileUrl)!)
      } else {
        self.profileImageStatus = .withoutImage(
          colorHex: user.profileData.profileColor.colorHex ?? "#FFD41F", name: user.nickname)
      }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 64, height: 64)
            
            VStack {
                Text("\(suggestedUser.nickname)")
                    .b1Style()
                    .foregroundColor(.odya.label.normal)
                    .lineLimit(1)
                Text("함께 아는 친구 0명")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
            }.frame(maxHeight: 35)
            
            FollowButton(isFollowing: followState, buttonStyle: .solid) {
                followState.toggle()
            }
        }.frame(width: 96)
    }
}

struct UserSuggestionView: View {
    @State var suggestedUsers: [FollowUserData] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("알 수도 있는 친구")
                .h6Style()
                .foregroundColor(.odya.label.normal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(suggestedUsers, id: \.self) { suggestedUser in
                        SuggestedUserView(user: suggestedUser)
                    }
                }
            }
        }
        .padding(.horizontal, GridLayout.side)
        .padding(.vertical, 28)
        .background(Color.odya.elevation.elev2)
        .cornerRadius(Radius.medium)
        .onAppear() {
            for i in 0...10 {
                suggestedUsers.append(FollowUserData(userId: i, nickname: "홍길동aa\(i)", profileData: ProfileData(profileColor: ProfileColorData(colorHex: "#FFD41F"))))
            }
        }
    }
}

struct UserSuggestion_Preview: PreviewProvider {
    static var previews: some View {
        UserSuggestionView()
    }
}
