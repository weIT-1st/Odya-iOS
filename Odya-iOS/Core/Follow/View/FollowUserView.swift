//
//  FollowUserView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/16.
//

import SwiftUI

// MARK: Follow User View

/// 팔로워/팔로잉 리스트에서 팔로우유저 뷰
/// 팔로우 유저의 프로필 사진과 닉네임을 포함
/// 클릭 시 해당 유저의 프로필 뷰로 이동
struct FollowUserView: View {
  let user: FollowUserData
  @State private var isShowingUserProfileView: Bool = false
  var body: some View {
    Button(action: {
      isShowingUserProfileView = true
    }) {
      HStack(spacing: 0) {
        ProfileImageView(of: user.nickname, profileData: user.profile, size: .S)
          .padding(.trailing, 12)
        Text(user.nickname)
          .foregroundColor(.odya.label.normal)
          .b1Style()
          .padding(.trailing, 4)
        Image("sparkle-s")
      }
    }.fullScreenCover(isPresented: $isShowingUserProfileView) {
      ProfileView(userId: user.userId, nickname: user.nickname, profileUrl: user.profile.profileUrl)
    }
  }
}

// MARK: Following User Row View

/// 팔로잉 리스트의 row 뷰
/// 팔로잉 유저의 프로필사진, 닉네임(팔로우 유저 뷰)과 팔로잉 버튼 포함
struct FollowingUserRowView: View {
  @EnvironmentObject var followHubVM: FollowHubViewModel

  let followUser: FollowUserData
  @State private var followState: Bool = true
  @State private var showUnfollowingAlert: Bool = false

  init(of followUser: FollowUserData) {
    self.followUser = followUser
  }

  var body: some View {
    HStack {
      FollowUserView(user: followUser)
      Spacer()
      if followHubVM.userID == MyData.userID {
        FollowButtonWithAlertAndApi(userId: followUser.userId, buttonStyle: .solid)
      }
    }
    .frame(height: 36)
    .padding(.horizontal, GridLayout.side)
  }
}

// MARK: Follower User Row View

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
      FollowUserView(user: followUser)
      Spacer()
      if followHubVM.userID == MyData.userID {
        followerDeletionButton
      }
    }
    .frame(height: 36)
    .padding(.horizontal, GridLayout.side)
  }
  
  private var followerDeletionButton: some View {
    Button(action: {
      showingFollwerDeleteAlert = true
      print("팔로워 삭제")
    }) {
      Text("삭제")
        .foregroundColor(Color.odya.label.inactive)
        .frame(width: 36)
        .detail1Style()
        .padding(8)
        .overlay(
          RoundedRectangle(cornerRadius: Radius.small)
            .stroke(Color.odya.label.inactive)
        )
    }
    .alert("팔로워를 삭제하시겠습니까?", isPresented: $showingFollwerDeleteAlert) {
      HStack {
        Button("취소") {
          showingFollwerDeleteAlert = false
        }
        Button("삭제") {
          print("팔로워 삭제됨")
          showingFollwerDeleteAlert = false
        }
      }
    } message: {
      Text("팔로워 삭제는 알림이 가지 않으며, 삭제 시 특정 여행일지 및 게시글이 노출되지 않습니다.")
    }
  }
}
