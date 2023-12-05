//
//  FollowButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/24.
//

import SwiftUI

extension View {
    func FollowButton(isFollowing: Bool, buttonStyle: ButtonStyleType,
                          action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(isFollowing ? "팔로잉" : "팔로우")
                .detail1Style()
                .padding(8)
        }.buttonStyle(CustomButtonStyle(cornerRadius: Radius.small, state: isFollowing ? .inactive : .active, style: buttonStyle))
    }
}

/// 팔로우/언팔로우 액션 및 alert 가 적용된 팔로우버튼
/// userId : 팔로우/언팔로우할 대상의 userId
/// buttonStyle: 팔로우버튼 스타일
/// followState: 팔로우 상태 초기값, 기본값은 true(팔로우 중인 상태)
struct FollowButtonWithAlertAndApi: View {
  @StateObject var followHubVM = FollowHubViewModel()
  
  let userId: Int
  let buttonStyle: ButtonStyleType
  @State private var followState: Bool
  @State private var isShowingUnfollowingAlert: Bool = false
  
  init(userId: Int, buttonStyle: ButtonStyleType, followState: Bool) {
    self.userId = userId
    self.buttonStyle = buttonStyle
    self.followState = followState
  }
  
  var body: some View {
    FollowButton(isFollowing: followState, buttonStyle: buttonStyle) {
      if followState == false {  // do following
        followState = true
        followHubVM.createFollow(userId)
      } else {  // do unfollowing
        isShowingUnfollowingAlert = true
      }
    }
    .animation(.default, value: followState)
    .alert("팔로잉을 취소하시겠습니까?", isPresented: $isShowingUnfollowingAlert) {
      HStack {
        Button("취소") {
          followState = true
          isShowingUnfollowingAlert = false
        }
        Button("삭제") {
          followState = false
          followHubVM.deleteFollow(userId)
          isShowingUnfollowingAlert = false
        }
      }
    } message: {
      Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
    }
  }
}
