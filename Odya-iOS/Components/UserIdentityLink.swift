//
//  UserIdentityLink.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

// MARK: User Identity Link

/// 유저 프로필이미지, 닉네임으로 구성된 HStack 뷰
/// 클릭 시 해당 유저의 프로필 뷰로 이동
struct UserIdentityLink: View {
  let userId: Int
  let nickname: String
  let profileUrl: String
  let profileSize: ComponentSizeType
  let isFollowing: Bool?
  
  // 유저의 프로필 뷰 화면 표시 여부
  @State private var isShowingUserProfileView: Bool = false
  
  // MARK: - Init
  init(userId: Int, nickname: String, profileUrl: String, profileSize: ComponentSizeType = .S, isFollowing: Bool? = nil) {
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.profileSize = profileSize
    self.isFollowing = isFollowing
  }
  
  // MARK: -- Body
  var body: some View {
    Button(action: {
      isShowingUserProfileView = true
    }) {
      HStack(spacing: 0) {
        // 프로필 이미지
        ProfileImageView(profileUrl: profileUrl, size: profileSize)
          .padding(.trailing, 12)
        
        // 닉네임
        Text(nickname)
          .foregroundColor(.odya.label.normal)
          .b1Style()
          .padding(.trailing, 4)
        
        // 스파클 이미지
        Image("sparkle-s")
      }
    }
    // 내 프로필 뷰로는 이동 불가능
    .disabled(userId == MyData.userID)
    // 프로필 뷰
    .fullScreenCover(isPresented: $isShowingUserProfileView) {
      ProfileView(userId: userId,
                  nickname: nickname,
                  profileUrl: profileUrl,
                  isFollowing: isFollowing)
    }
  }
}


// MARK: User Identity Row With Following

/// UserIdentityLink와 팔로잉 버튼으로 구성된 row
struct UserIdentityRowWithFollowing: View {
  let userId: Int
  let nickname: String
  let profileUrl: String
  let isFollowing: Bool

  // MARK: -- Init
  
  // FollowUserData
  init(of followUser: FollowUserData) {
    self.userId = followUser.userId
    self.nickname = followUser.nickname
    self.profileUrl = followUser.profile.profileUrl
    self.isFollowing = true
  }
  
  // Writer
  init(of writer: Writer) {
    self.userId = writer.userID
    self.nickname = writer.nickname
    self.profileUrl = writer.profile.profileUrl
    self.isFollowing = writer.isFollowing ?? true
  }
  
  // basic
  init(userId: Int, nickname: String, profileUrl: String, isFollowing: Bool) {
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.isFollowing = isFollowing
  }

  // MARK: -- Body
  var body: some View {
    HStack {
      UserIdentityLink(userId: userId, nickname: nickname, profileUrl: profileUrl, isFollowing: isFollowing)
      Spacer()
      FollowButtonWithAlertAndApi(userId: userId, buttonStyle: .solid, followState: isFollowing)
    }
    .frame(height: 36)
  }
}

