//
//  UserSuggestion.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/11.
//

import SwiftUI

// MARK: Suggested User View

/// 알 수도 있는 친구 추천 리스트의 추천된 유저 뷰
struct SuggestedUserView: View {
  @EnvironmentObject var followHubVM: FollowHubViewModel

  let user: FollowUserData

  @State private var followState: Bool = false
  @State private var showUnfollowingAlert: Bool = false

  var body: some View {
    VStack(spacing: 16) {
        ProfileImageView(of: user.nickname, profileData: user.profile, size: .L)

      VStack {
        Text("\(user.nickname)")
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .lineLimit(1)
        /* 개발 보류... !!
                Text("함께 아는 친구 n명")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
                 */
      }.frame(maxHeight: 35)
      FollowButtonWithAlertAndApi(userId: user.userId, buttonStyle: .solid, followState: false)
    }.frame(width: 96)
  }
}

// MARK: User Suggestion View

/// 알 수도 있는 친구 추천 리스트 뷰
struct UserSuggestionView: View {
  @EnvironmentObject var followHubVM: FollowHubViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("알 수도 있는 친구")
        .h6Style()
        .foregroundColor(.odya.label.normal)

      if followHubVM.isLoadingSuggestion {  // 로딩 중
        HStack {
          Spacer()
          ProgressView()
          Spacer()
        }
      } else if followHubVM.suggestedUsers.isEmpty {  // 추천 친구 없음
        HStack {
          Spacer()
          Text("추천 가능한 친구가 없어요!!")
            .detail1Style()
            .foregroundColor(.odya.label.assistive)
          Spacer()
        }.padding(.bottom, 24)
      } else {  // 추천 친구 있음
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
      followHubVM.getSuggestion { _ in }
    }
  }

}

//struct UserSuggestion_Preview: PreviewProvider {
//    static var previews: some View {
//        UserSuggestionView()
//    }
//}
