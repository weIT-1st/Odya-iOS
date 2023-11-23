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
  @StateObject private var followViewModel = FollowButtonViewModel()
  /// 팔로우 상태 토글
  @State private var followState: Bool
  
  // Like
  @StateObject private var likeViewModel = CommunityLikeViewModel()

  // Feed Content
  let communityId: Int
  let contentText: String
  let commentCount: Int
  @State var likeCount: Int
  let createDate: String
  let writer: Writer
  @State var isUserLiked: Bool

  // MARK: Init

  init(communityId: Int, contentText: String, commentCount: Int, likeCount: Int, createDate: String, writer: Writer, isUserLiked: Bool) {
    self.communityId = communityId
    self.contentText = contentText
    self.commentCount = commentCount
    self.likeCount = likeCount
    self.createDate = createDate
    self.writer = writer
    self.followState = writer.isFollowing ?? false
    self.isUserLiked = isUserLiked
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
  
  enum HeartImage: String {
    case mOff = "heart-off-m"
    case lOn = "heart-on-l"
    case sOn = "heart-on-s"
    case sOff = "heart-off-s"
    
    func nextOn() -> HeartImage {
      switch self {
      case .mOff: return .lOn
      case .lOn: return .sOn
      default: return .sOn
      }
    }
    
    func nextOff() -> HeartImage {
      switch self {
      case .sOn: return .sOff
      case .sOff: return .mOff
      default: return .mOff
      }
    }
  }
  
  @State private var likeImageName = HeartImage.mOff
  
  private var likeView: some View {
    HStack(spacing: 4) {
      VStack {
        if isUserLiked {
          Image(likeImageName.rawValue)
        } else {
          Image(likeImageName.rawValue)
            .renderingMode(.template)
            .foregroundColor(Color.odya.label.assistive)
  //            .padding(6)
  //            .frame(width: 24, height: 24)
        }
      }
      .onTapGesture {
        print("좋아요 버튼 눌림!!!!")
        if isUserLiked {
          withAnimation(.spring()) {
            // 좋아요 삭제
            isUserLiked = false
            likeCount -= 1
            likeViewModel.deleteLike(communityId: communityId)
            
            likeImageName = likeImageName.nextOff()
            print(likeImageName.rawValue)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              likeImageName = likeImageName.nextOff()
              print(likeImageName.rawValue)
            }
          }
        } else {
          withAnimation(.spring()) {
            // 좋아요 생성
            isUserLiked = true
            likeCount += 1
            likeViewModel.createLike(communityId: communityId)
            
            likeImageName = likeImageName.nextOn()
            print(likeImageName.rawValue)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              likeImageName = likeImageName.nextOn()
              print(likeImageName.rawValue)
            }
          }
        }
      }
      .onAppear {
        likeImageName = isUserLiked ? HeartImage.sOn : HeartImage.mOff
      }

      
      // 좋아요 버튼
//      Button {
//        if isUserLiked {
//          withAnimation(.spring()) {
//            // 좋아요 삭제
//            isUserLiked = false
//            likeCount -= 1
//            likeViewModel.deleteLike(communityId: communityId)
//
//            likeImageName = likeImageName.nextOff()
//            print(likeImageName.rawValue)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//              likeImageName = likeImageName.nextOff()
//              print(likeImageName.rawValue)
//            }
//          }
//        } else {
//          withAnimation(.spring()) {
//            // 좋아요 생성
//            isUserLiked = true
//            likeCount += 1
//            likeViewModel.createLike(communityId: communityId)
//
//            likeImageName = likeImageName.nextOn()
//            print(likeImageName.rawValue)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//              likeImageName = likeImageName.nextOn()
//              print(likeImageName.rawValue)
//            }
//          }
//        }
//      } label: {
//        if isUserLiked {
//          Image(likeImageName.rawValue)
//        } else {
//          Image(likeImageName.rawValue)
//            .renderingMode(.template)
//            .foregroundColor(Color.odya.label.assistive)
////            .padding(6)
////            .frame(width: 24, height: 24)
//        }
//      }
//      .onTapGesture {
//        print("좋아요 버튼 눌림!!!!")
//      }
//      .onAppear {
//        likeImageName = isUserLiked ? HeartImage.sOn : HeartImage.mOff
//      }

      // 좋아요 수
      Text(likeCount > 99 ? "99+" : "\(likeCount)")
        .detail1Style()
        .foregroundColor(Color.odya.label.assistive)
    }
    .padding(.trailing, 12)
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
      communityId: 1, contentText: "커뮤니티 게시글 내용", commentCount: 99, likeCount: 99, createDate: "2023-01-01",
      writer: Writer(
        userID: 1, nickname: "홍길동", profile: ProfileData(profileUrl: ""), isFollowing: false), isUserLiked: true)
  }
}
