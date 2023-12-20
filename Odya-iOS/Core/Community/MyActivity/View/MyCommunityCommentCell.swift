//
//  MyCommunityCommentCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/15.
//

import SwiftUI

/// 내 커뮤니티 활동 - 댓글 셀
struct MyCommunityCommentCell: View {
  // MARK: Property
  /// 피드, 댓글 내용
  let content: MyCommunityCommentsContent
  
  // MARK: Body
  var body: some View {
    HStack(alignment: .top, spacing: 9) {
      ProfileImageView(of: "", profileData: content.writer.profile, size: .S)
      
      VStack(spacing: 10) {
        // feed
        simpleFeedContent
        
        // comment
        HStack(alignment: .top, spacing: 10) {
          ProfileImageView(of: "", profileData: content.communityCommentSimpleResponse.user.profile, size: .S)
          simpleCommentContent
        }
      }
    }
  }
  
  /// 간략한 피드 내용
  private var simpleFeedContent: some View {
    HStack(alignment: .center, spacing: 10) {
      VStack(alignment: .leading, spacing: 10) {
        // feed writer nickname
        HStack(alignment: .center) {
          Text(content.writer.nickname)
            .b1Style()
            .foregroundColor(.odya.label.normal)
          // feed content
          Text(content.communityContent)
            .detail2Style()
            .foregroundColor(.odya.label.normal)
            .lineLimit(1)
        }
        Text(content.updatedAt.toCustomRelativeDateString())
          .detail1Style()
          .foregroundColor(.odya.label.assistive)
      }
      Spacer()
      AsyncImageView(url: content.communityMainImageURL, width: 60, height: 60, cornerRadius: 0)
        .frame(width: 60, height: 60)
    }
  }
  
  /// 간략한 댓글 내용
  private var simpleCommentContent: some View {
    VStack(alignment: .leading, spacing: 16) {
      // comment writer nickname
      HStack {
        Text(content.communityCommentSimpleResponse.user.nickname)
          .b1Style()
          .foregroundColor(.odya.label.normal)
        Spacer()
      }
      VStack(alignment: .leading, spacing: 4) {
        // comment content
        Text(content.communityCommentSimpleResponse.content)
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .lineLimit(3)
          .multilineTextAlignment(.leading)
        HStack {
          Text(content.communityCommentSimpleResponse.updatedAt.toCustomRelativeDateString())
            .detail1Style()
            .foregroundColor(.odya.label.assistive)
          Spacer()
        }
      }
    }
    .padding(.vertical, 4)
  }
}

// MARK: - Previews
struct MyCommunityCommentCell_Previews: PreviewProvider {
  static var previews: some View {
    MyCommunityCommentCell(content: MyCommunityCommentsContent(communityID: 1, communityContent: "피드 게시글 내용 피드 게시글 내용 피드 게시글 내용", communityMainImageURL: "", updatedAt: "2023.12.12", writer: Writer(userID: 1, nickname: "길동아밥먹자", profile: ProfileData(profileUrl: ""), isFollowing: true), communityCommentSimpleResponse: CommunityCommentSimpleResponse(communityCommentID: 1, content: "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라", updatedAt: "2023.12.15", user: Writer(userID: 2, nickname: "홍길동", profile: ProfileData(profileUrl: ""), isFollowing: nil))))
      .frame(height: 200)
  }
}
