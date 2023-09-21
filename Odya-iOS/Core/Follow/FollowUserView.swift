//
//  FollowUserView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/16.
//

import SwiftUI

/// 팔로워/팔로잉 리스트에서 팔로우유저 뷰
/// 팔로우 유저의 프로필 사진과 닉네임을 포함
/// 클릭 시 해당 유저의 프로필 뷰로 이동
struct FollowUserView: View {
  private let userData: FollowUserData
  private let status: ProfileImageStatus

    init(user: FollowUserData) {
        self.userData = user
        if let profileColor = user.profile.profileColor {
            self.status = .withoutImage(
                colorHex: profileColor.colorHex, name: user.nickname)
        } else {
            self.status = .withImage(url: URL(string: user.profile.profileUrl)!)
        }
    }

  var body: some View {
    NavigationLink(destination: UserProfileView(userData: userData)) {
      HStack(spacing: 0) {
        ProfileImageView(status: status, sizeType: .S)
          .padding(.trailing, 12)
        Text(userData.nickname)
          .foregroundColor(.odya.label.normal)
          .b1Style()
          .padding(.trailing, 4)
        Image("sparkle-s")
      }
    }
  }
}

/// 팔로잉 리스트의 row 뷰
/// 팔로잉 유저의 프로필사진, 닉네임(팔로우 유저 뷰)과 팔로잉 버튼 포함
struct FollowingUserRowView: View {
    
    var userData: FollowUserData
    @State private var followState: Bool = true
    @State private var showUnfollowingAlert: Bool = false
    
    var body: some View {
        HStack {
            FollowUserView(user: userData)
            Spacer()
            FollowButton(isFollowing: followState, buttonStyle: .solid) {
                if followState == false { // do following
                    followState = true
                    // following api
                } else { // do unfollowing
                    showUnfollowingAlert = true
                }
            }
            .animation(.default, value: followState)
        }
        .frame(height: 36)
        .padding(.horizontal, GridLayout.side)
        .alert("팔로잉을 취소하시겠습니까?", isPresented: $showUnfollowingAlert) {
            HStack {
                Button("취소") {
                    followState = true
                    showUnfollowingAlert = false
                }
                Button("삭제") {
                    followState = false
                    // unfollowing api
                    showUnfollowingAlert = false
                }
            }
        } message: {
            Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
        }
    }
}

/// 팔로워 리스트의 row 뷰
/// 팔로워 유저의 프로필사진, 닉네임(팔로우 유저 뷰)과 삭제 버튼 포함
struct FollowerUserRowView: View {
    let userData: FollowUserData
    @State private var showingFollwerDeleteAlert: Bool = false
    
    var body: some View {
        HStack {
            FollowUserView(user: userData)
            Spacer()
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
            .alert("팔로잉을 취소하시겠습니까?", isPresented: $showingFollwerDeleteAlert) {
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
        .frame(height: 36)
        .padding(.horizontal, GridLayout.side)
    }
}
