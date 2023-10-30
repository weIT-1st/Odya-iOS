//
//  FeedCommentView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedCommentView: View {
  // MARK: Properties
  @State private var showCommentSheet = false
  @State private var showFullCommentSheet = false

  // MARK: Body

  var body: some View {
    VStack(spacing: 24) {
      // full comment button
      Button {
        // action: open bottom sheet
        showCommentSheet.toggle()
      } label: {
        HStack(spacing: 10) {
          Text("12개의 댓글 더보기")
            .detail1Style()
            .foregroundColor(Color.odya.label.assistive)
          // image >
        }
        .padding(.vertical, 8)
        .frame(height: 36)
        .frame(maxWidth: .infinity)
        .background(Color.odya.elevation.elev3)
        .cornerRadius(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .inset(by: 0.5)
            .stroke(Color.odya.line.alternative, lineWidth: 1)
        )
      }
      .sheet(isPresented: $showCommentSheet) {
        FeedFullCommentSheet(isEditing: false)
          .presentationDetents([.medium, .large])
      }

      // comments top 2
      VStack(spacing: 16) {
        FeedCommentCell()

        Divider()

        FeedCommentCell()
      }

      // write comment btn
      Button {
        // open bottom sheet
        showFullCommentSheet.toggle()
      } label: {
        HStack(alignment: .center, spacing: 16) {
          // user profile image
          Image("profile")
            .resizable()
            .frame(
              width: ComponentSizeType.XS.ProfileImageSize,
              height: ComponentSizeType.XS.ProfileImageSize)

          Text("댓글을 입력해주세요")
            .b1Style()
            .foregroundColor(Color.odya.label.inactive)

          Spacer()

          Image("smallGreyButton-send")
            .renderingMode(.template)
            .foregroundColor(Color.odya.label.assistive)
            .frame(width: 24, height: 24)
        }
        .frame(height: 48)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(Color.odya.elevation.elev5)
        .cornerRadius(Radius.medium)
      }
      .sheet(isPresented: $showFullCommentSheet) {
        FeedFullCommentSheet(isEditing: true)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 24)
    .padding(.horizontal, GridLayout.side)
    .background(Color.odya.elevation.elev2)
    .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
  }
}

// MARK: - FeedCommentCell

struct FeedCommentCell: View {
  var body: some View {
    VStack(spacing: 12) {
      // user, menu
      HStack {
        FeedUserInfoView(profileImageSize: ComponentSizeType.XS.ProfileImageSize, writer: Writer(userID: 1, nickname: "닉네임", profile: ProfileData(profileUrl: ""), isFollowing: false), createDate: "2023-10-30")
        Spacer()
        Menu {
          Button("수정") {
            // action: 댓글 수정
          }
          Button("삭제") {
            // action: 댓글 삭제
          }
        } label: {
          Image("menu-kebob")
            .frame(width: 24, height: 24)
        }
      }

      // comment text
      Text("형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다.")
        .detail2Style()
        .foregroundColor(Color.odya.label.assistive)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
  }
}

// MARK: - Preview

struct CommentView_Previews: PreviewProvider {
  static var previews: some View {
    FeedCommentView()
  }
}
