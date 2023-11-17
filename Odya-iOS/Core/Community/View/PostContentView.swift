//
//  PostContentView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct PostContentView: View {
  // MARK: Properties
  // Follow
  /// 팔로잉 취소 버튼 탭 alert
  @State private var showUnfollowAlert: Bool = false
  /// 팔로우버튼 뷰모델
  @State private var followViewModel = FollowButtonViewModel()
  /// 팔로우 상태 토글
  @State private var followState: Bool

  // Feed Content
  let contentText: String
  let commentCount: Int
  let likeCount: Int
  let createDate: String
  let writer: Writer

  // MARK: Init

  init(contentText: String, commentCount: Int, likeCount: Int, createDate: String, writer: Writer) {
    self.contentText = contentText
    self.commentCount = commentCount
    self.likeCount = likeCount
    self.createDate = createDate
    self.writer = writer
    self.followState = writer.isFollowing ?? false
  }

  // MARK: Body

  var body: some View {
    VStack {
      // 유저 정보
      HStack {
        FeedUserInfoView(
          profileImageSize: .S,
          writer: writer,
          createDate: createDate
        )
        Spacer()
        // 팔로우버튼
        if writer.userID != MyData.userID {
          followButton
        }
      }
      .frame(height: 32)

      // 게시글 내용
      Text(contentText)
        .detail2Style()
        .multilineTextAlignment(.leading)
        .foregroundColor(Color.odya.label.normal)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .lineLimit(2)

      /// 장소, 좋아요, 댓글
      VStack {
        HStack {
          locationView
          Spacer()
          likeView
          commentView
        }
        .padding(8)
      }
      .background(Color.odya.elevation.elev3)
      .cornerRadius(Radius.medium)

    }  // VStack
    .padding(.vertical, 16)
    .padding(.horizontal, 18)
    .background(Color.odya.elevation.elev2)
    .clipShape(RoundedEdgeShape(edgeType: .bottom))
  }

  /// Location
  private var locationView: some View {
    HStack(spacing: 4) {
      Image("location-m")
        .renderingMode(.template)
        .foregroundColor(Color.odya.label.assistive)

      // 장소명
      Text("오이도")
        .detail2Style()
        .foregroundColor(Color.odya.label.assistive)
    }
  }

  /// Like
  private var likeView: some View {
    HStack(spacing: 4) {
      // 좋아요 버튼
      Button {
        // action
      } label: {
        Image("heart-off-m")
          .renderingMode(.template)
          .foregroundColor(Color.odya.label.assistive)
      }

      // 좋아요 수
      Text("\(likeCount)")
        .detail1Style()
        .foregroundColor(Color.odya.label.assistive)
    }
    .padding(.trailing, 12)
  }

  /// Comment
  private var commentView: some View {
    HStack(spacing: 4) {
      // 댓글 버튼
      Button {
        // action
      } label: {
        Image("comment")
          .renderingMode(.template)
          .foregroundColor(Color.odya.label.assistive)
      }

      // 댓글 수
      Text("\(commentCount)")
        .detail1Style()
        .foregroundColor(Color.odya.label.assistive)
    }
  }
  
  /// Follow
  private var followButton: some View {
    VStack(spacing: 0) {
      FollowButton(isFollowing: followState, buttonStyle: .ghost) {
        if followState == true {
          // 이미 팔로우하고 있는 경우 -> 팔로우취소
          showUnfollowAlert = true
        } else {
          // 팔로우하지 않은 경우 -> 팔로우
          followState = true
          followViewModel.createFollow(writer.userID)
        }
      }
    }
    .alert("팔로잉을 취소하시겠습니까?", isPresented: $showUnfollowAlert) {
      Button("닫기", role: .cancel) { }
      Button("삭제", role: .destructive) {
        followState = false
        followViewModel.deleteFollow(writer.userID)
      }
    } message: {
      Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
    }
  }
}

// MARK: - Preview
struct PostContentView_Previews: PreviewProvider {
  static var previews: some View {
    PostContentView(
      contentText: "커뮤니티 게시글 내용", commentCount: 99, likeCount: 99, createDate: "2023-01-01",
      writer: Writer(
        userID: 1, nickname: "홍길동", profile: ProfileData(profileUrl: ""), isFollowing: false))
  }
}
