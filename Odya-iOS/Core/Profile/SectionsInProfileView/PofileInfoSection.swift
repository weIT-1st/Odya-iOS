//
//  PofileSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import Photos
import SwiftUI

// MARK: Profile Image Edit Button

/// 프로필이미지 변경 버튼
private struct ProfileImageEditButton: View {
  @EnvironmentObject var profileVM: ProfileViewModel

  @State private var isShowingUpdateProfileImageAlert: Bool = false
  @State private var isShowingImagePickerSheet: Bool = false

  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
  @State private var selectedImage: [ImageData] = []

  var body: some View {
    IconButton("camera") {
      isShowingUpdateProfileImageAlert = true
    }
    .disabled(profileVM.isUpdatingProfileImg)
    .background(Color.odya.label.inactive)
    .cornerRadius(50)
    .offset(
      x: ComponentSizeType.XL.ProfileImageSize / 2 - 15,
      y: ComponentSizeType.XL.ProfileImageSize / 2 - 15
    )
    // 프로필 이미지 변경 방식 선택 alert
    .confirmationDialog("", isPresented: $isShowingUpdateProfileImageAlert) {
      Button("앨범에서 사진 선택") {
        isShowingUpdateProfileImageAlert = false
        isShowingImagePickerSheet = true
      }
      Button("기본 이미지로 변경") {
        isShowingUpdateProfileImageAlert = false
        // api with Null
        Task {
          await profileVM.updateProfileImage(newProfileImg: [])
        }
      }
      Button("취소", role: .cancel) { print("취소 클릭") }
    }
    // 포토피커 띄우기
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $selectedImage, maxImageCount: 1, accessStatus: imageAccessStatus)
    }
    // 포토피커로 고른 사진으로 프로필 이미지 변경
    .onChange(of: selectedImage) { newValue in
      if newValue.count == 1 {
        print("get new profile image")
        // api with UIImage
        Task {
          await profileVM.updateProfileImage(newProfileImg: newValue)
        }
        selectedImage = []
      }
    }
  }
}

// MARK: Follow Button In ProfileView

/// 타인의 프로필 뷰의 팔로잉 버튼
/// 팔로우/언팔로우 시 follow Count 값을 같이 바꿔줌
private struct FollowButtonInProfileView: View {
  @StateObject var VM = FollowButtonViewModel()

  let userId: Int
  @Binding var followerCount: Int

  @State private var followState: Bool

  @State private var isShowingUnfollowingAlert: Bool = false

  init(userId: Int, followerCount: Binding<Int>, isFollowing: Bool?) {
    self.userId = userId
    self._followerCount = followerCount
    if let isFollowing = isFollowing {
      self.followState = isFollowing
    } else {
      self.followState = false
      FollowButtonViewModel().isMyFollowingUser(userId) { [self] result in
        self.followState = result
      }
    }
  }

  var body: some View {
    FollowButton(
      isFollowing: followState,
      buttonStyle: .solid
    ) {
      if followState == false {  // do following
        followState = true
        // 팔로우 -> 팔로워 수 1 증가
        followerCount += 1
        VM.createFollow(userId)
      } else {  // do unfollowing
        isShowingUnfollowingAlert = true
      }
    }
    .animation(.default, value: followState)
    .alert("팔로잉을 취소하시겠습니까?", isPresented: $isShowingUnfollowingAlert) {
      HStack {
        Button("취소") {
          isShowingUnfollowingAlert = false
        }
        Button("삭제") {
          followState = false
          // 언팔로우 -> 팔로워 수 1 감소
          followerCount -= 1
          VM.deleteFollow(userId)
          isShowingUnfollowingAlert = false
        }
      }
    } message: {
      Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
    }
  }
}

// MARK: Profile Info Section
extension ProfileView {
  var profileImgAndNickname: some View {
    VStack(spacing: 24) {
      // profile image
      ZStack {
        ProfileImageView(profileUrl: profileVM.profileUrl, size: .XL)

        if isMyProfile {
          ProfileImageEditButton()
            .environmentObject(profileVM)
        }
      }

      // nickname
      HStack(spacing: 12) {
        Text(profileVM.nickname)
          .foregroundColor(.odya.label.normal)
          .h3Style()

        // if not my profile, follow button
        if !isMyProfile {
          FollowButtonInProfileView(
            userId: profileVM.userID,
            followerCount: $profileVM.statistics.followersCount,
            isFollowing: isFollowing)
        }
      }
    }  // VStack
  }

}
