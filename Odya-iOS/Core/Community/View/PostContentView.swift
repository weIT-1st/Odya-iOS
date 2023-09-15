//
//  PostContentView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct PostContentView: View {
  // MARK: - Body

  var body: some View {
    VStack(spacing: 12) {
      // 유저 정보
      HStack {
        // 유저 프로필
        Image("profile")
          .frame(
            width: ComponentSizeType.M.ProfileImageSize,
            height: ComponentSizeType.M.ProfileImageSize)

        FeedUserInfoView()
      }
      .frame(height: 32)

      // 게시글 내용
      Text(
        "오늘 졸업 여행으로 오이도에 다녀왔어요! 생각보다 추웠지만 너무 재밌었습니다! 맛있는 회도 먹고 친구들과 좋은 시간도 보내고 왔습니다 ㅎㅎ 다들 졸업 축하해 ~"
      )
      .detail2Style()
      .multilineTextAlignment(.leading)
      .foregroundColor(Color.odya.label.normal)
      .frame(alignment: .topLeading)
      .lineLimit(2)

      // 장소, 좋아요, 댓글
      VStack {
        HStack {
          // 장소
          HStack(spacing: 4) {
            Image("location-m")
              .renderingMode(.template)
              .foregroundColor(Color.odya.label.assistive)

            // 장소명
            Text("오이도")
              .detail2Style()
              .foregroundColor(Color.odya.label.assistive)
          }

          Spacer()

          // 좋아요
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
            Text("99+")
              .detail1Style()
              .foregroundColor(Color.odya.label.assistive)
          }
          .padding(.trailing, 12)

          // 댓글
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
            Text("99+")
              .detail1Style()
              .foregroundColor(Color.odya.label.assistive)
          }
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
}

// MARK: - Preview
struct PostContentView_Previews: PreviewProvider {
  static var previews: some View {
    PostContentView()
  }
}
