//
//  FollowerUserRowView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/16.
//

import SwiftUI

/// 팔로워 리스트의 row 뷰
/// 팔로워 유저의 프로필사진, 닉네임(팔로우 유저 뷰)과 삭제 버튼 포함
struct FollowerUserRowView: View {
  @EnvironmentObject var followHubVM: FollowHubViewModel

  let followUser: FollowUserData
  @State private var showingFollwerDeleteAlert: Bool = false

  init(of followUser: FollowUserData) {
    self.followUser = followUser
  }

  var body: some View {
    HStack {
      UserIdentityLink(userId: followUser.userId,
                       nickname: followUser.nickname,
                       profileUrl: followUser.profile.profileUrl)
      Spacer()
      if followHubVM.userID == MyData.userID {
        followerDeletionButton
      }
    }
    .frame(height: 36)
  }
  
  private var followerDeletionButton: some View {
    Button(action: {
      showingFollwerDeleteAlert = true
      print("팔로워 삭제")
    }) {
      Text("삭제")
        .foregroundColor(Color.odya.label.inactive)
        .detail1Style()
        .frame(width: 38, height: 12)
        .padding(8)
        .overlay(
          RoundedRectangle(cornerRadius: Radius.small)
            .stroke(Color.odya.label.inactive)
        )
    }
    .alert("팔로워를 삭제하시겠습니까?", isPresented: $showingFollwerDeleteAlert) {
      Button("삭제") {
        print("팔로워 삭제됨")
        showingFollwerDeleteAlert = false
        // TODO: 팔로워 삭제 기능 연결
      }
    } message: {
      Text("팔로워 삭제는 알림이 가지 않으며, 삭제 시 특정 여행일지 및 게시글이 노출되지 않습니다.")
    }
  }
}
