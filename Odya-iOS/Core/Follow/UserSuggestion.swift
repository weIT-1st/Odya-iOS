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
        if let profileColor = user.profile.profileColor {
            self.profileImageStatus = .withoutImage(
                colorHex: profileColor.colorHex, name: user.nickname)
        } else {
            self.profileImageStatus = .withImage(url: URL(string: user.profile.profileUrl)!)
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
    @ObservedObject var followHubVM: FollowHubViewModel
    
    var body: some View {
        if followHubVM.suggestedUsers.count != 0 {
            VStack(alignment: .leading, spacing: 24) {
                Text("알 수도 있는 친구")
                    .h6Style()
                    .foregroundColor(.odya.label.normal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 32) {
                        ForEach(followHubVM.suggestedUsers) { suggestedUser in
                            SuggestedUserView(user: suggestedUser)
                        }
                    }
                }
            }
            .padding(.horizontal, GridLayout.side)
            .padding(.vertical, 28)
            .background(Color.odya.elevation.elev2)
            .cornerRadius(Radius.medium)
        }
    }
}

//struct UserSuggestion_Preview: PreviewProvider {
//    static var previews: some View {
//        UserSuggestionView()
//    }
//}
