//
//  UserSuggestion.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import SwiftUI

struct SuggestedUserView: View {
    @EnvironmentObject var followHubVM: FollowHubViewModel
    
    private let suggestedUser: FollowUserData
    private let profileImageStatus: ProfileImageStatus
    
    @State private var followState: Bool = false
    @State private var showUnfollowingAlert: Bool = false

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
                Text("함께 아는 친구 n명")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
            }.frame(maxHeight: 35)
            
            FollowButton(isFollowing: followState, buttonStyle: .solid) {
                if followState == false { // do following
                    followState = true
                    followHubVM.createFollow(suggestedUser.userId)
                } else { // do unfollowing
                    showUnfollowingAlert = true
                }
            }
            .alert("팔로잉을 취소하시겠습니까?", isPresented: $showUnfollowingAlert) {
                HStack {
                    Button("취소") {
                        followState = true
                        showUnfollowingAlert = false
                    }
                    Button("삭제") {
                        followState = false
                        followHubVM.deleteFollow(suggestedUser.userId)
                        showUnfollowingAlert = false
                    }
                }
            } message: {
                Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
            }
        }.frame(width: 96)
    }
}

struct UserSuggestionView: View {
    @EnvironmentObject var followHubVM: FollowHubViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("알 수도 있는 친구")
                .h6Style()
                .foregroundColor(.odya.label.normal)
            
            
            if followHubVM.isLoadingSuggestion {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if followHubVM.suggestedUsers.isEmpty {
                HStack {
                    Spacer()
                    Text("추천 가능한 친구가 없어요!!")
                        .detail1Style()
                        .foregroundColor(.odya.label.assistive)
                    Spacer()
                }.padding(.bottom, 24)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 32) {
                        ForEach(followHubVM.suggestedUsers) { suggestedUser in
                            SuggestedUserView(user: suggestedUser)
                                .environmentObject(followHubVM)
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal, GridLayout.side)
        .padding(.vertical, 28)
        .background(Color.odya.elevation.elev2)
        .cornerRadius(Radius.medium)
        .onAppear {
            followHubVM.initSuggestData()
            followHubVM.suggestUsers()
        }
    }
    

}

//struct UserSuggestion_Preview: PreviewProvider {
//    static var previews: some View {
//        UserSuggestionView()
//    }
//}
