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
  /// 팔로우 상태 토글
  @State private var followState: Bool

  // Feed Content
  let communityId: Int
  let contentText: String
  let commentCount: Int
  @State var likeCount: Int
  let placeId: String?
  let createDate: String
  let writer: Writer
  @State var isUserLiked: Bool

  // MARK: Init

  init(post: FeedContent) {
    self.communityId = post.communityId
    self.contentText = post.communityContent
    self.commentCount = post.communityCommentCount
    self._likeCount = State(initialValue: post.communityLikeCount)
    self.placeId = post.placeId
    self.createDate = post.createdDate
    self.writer = post.writer
    self.followState = post.writer.isFollowing ?? false
    self._isUserLiked = State(initialValue: post.isUserLiked)
  }
  
  // MARK: Body

  var body: some View {
    VStack {
      NavigationLink(value: FeedRoute.detail(communityId)) {
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
              FollowButtonWithAlertAndApi(userId: writer.userID, buttonStyle: .ghost, followState: writer.isFollowing ?? false)
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
        }
      }

      /// 장소, 좋아요, 댓글
      HStack(spacing: 12) {
        if let _ = placeId {
          locationView
        }
        Spacer()
        CommunityLikeButton(
          communityId: communityId,
          likeState: isUserLiked,
          likeCount: likeCount,
          baseColor: Color.odya.label.assistive
        )
        commentView
      }
      .padding(.horizontal, 8)
      .frame(height: 40)
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
      PlaceNameTextView(placeId: placeId)
        .detail2Style()
        .foregroundColor(Color.odya.label.assistive)
    }
  }

  /// Comment
  private var commentView: some View {
    HStack(spacing: 4) {
      Image("comment")
        .renderingMode(.template)
        .foregroundColor(Color.odya.label.assistive)

      // 댓글 수
      Text(commentCount > 99 ? "99+" : "\(commentCount)")
        .detail1Style()
        .foregroundColor(Color.odya.label.assistive)
    }
  }
}
