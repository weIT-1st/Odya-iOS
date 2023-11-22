//
//  FeedCommentView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedCommentView: View {
  // MARK: Properties
  
  /// 뷰모델
  @StateObject private var viewModel = CommentViewModel()
  
  /// 커뮤니티 아이디
  let communityId: Int
  /// 전체 댓글 개수
  let totalCommentCount: Int
  
  // MARK: Init
  
  init(communityId: Int, totalCommentCount: Int) {
    self.communityId = communityId
    self.totalCommentCount = totalCommentCount
  }
  
  // MARK: - Body

  var body: some View {
    VStack(spacing: 24) {
      // 댓글이 2개 이상일때, 댓글 더보기버튼 보여주기
      if totalCommentCount > 2 {
        fullCommentButton
      }

      // 댓글 2개만 미리보기
      VStack(spacing: 16) {
        ForEach(viewModel.state.content.prefix(2), id: \.communityCommentID) { content in
          FeedCommentCell(communityId: communityId, content: content)
            .environmentObject(viewModel)
          
          if content.communityCommentID != viewModel.state.content.last?.communityCommentID {
            Divider()
          }
        }
      }

      // 댓글 입력하기 버튼
      writeCommentButton
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 24)
    .padding(.horizontal, GridLayout.side)
    .background(Color.odya.elevation.elev2)
    .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
    .task {
      viewModel.fetchCommentNextPageIfPossible(communityId: communityId, size: 2)
    }
  }
  
  /// 댓글 더보기 버튼
  private var fullCommentButton: some View {
    Button {
      // action: open bottom sheet
      viewModel.showCommentSheet.toggle()
    } label: {
      HStack(spacing: 10) {
        Text("\(totalCommentCount - viewModel.state.content.prefix(2).count)개의 댓글 더보기")
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
    .sheet(isPresented: $viewModel.showCommentSheet) {
      FeedFullCommentSheet(isEditing: false, communityId: communityId)
        .environmentObject(viewModel)
        .presentationDetents([.medium, .large])
    }
  }
  
  /// 댓글 입력하기 버튼
  private var writeCommentButton: some View {
    Button {
      // open bottom sheet
      viewModel.showFullCommentSheet.toggle()
    } label: {
      HStack(alignment: .center, spacing: 16) {
        ProfileImageView(of: MyData().nickname,
                         profileData: MyData().profile.decodeToProileData(),
                         size: .XS)

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
    .sheet(isPresented: $viewModel.showFullCommentSheet) {
      FeedFullCommentSheet(isEditing: true, communityId: communityId)
        .environmentObject(viewModel)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
  }
}

// MARK: - FeedCommentCell

struct FeedCommentCell: View {
  // MARK: Properties
  
  @EnvironmentObject var viewModel: CommentViewModel
  
  let communityId: Int
  var content: CommentContent
  
  init(communityId: Int, content: CommentContent) {
    self.communityId = communityId
    self.content = content
  }
  
  // MARK: Body
  
  var body: some View {
    VStack(spacing: 12) {
      // user, menu
      HStack {
        FeedUserInfoView(
          profileImageSize: ComponentSizeType.XS,
          writer: content.user,
          createDate: content.updatedAt)
        Spacer()
        Menu {
          Button("수정") {
            // action: 댓글 수정
            viewModel.switchEditMode(content.communityCommentID, content.content)
          }
          Button("삭제") {
            // action: 댓글 삭제
            viewModel.deleteComment(communityId: communityId, commentId: content.communityCommentID)
          }
        } label: {
          Image("menu-kebob")
            .frame(width: 24, height: 24)
        }
      }

      // comment text
      Text(content.content)
        .detail2Style()
        .foregroundColor(Color.odya.label.assistive)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
      Button("닫기", role: .cancel) {
        // action?
      }
    } message: {
      Text(viewModel.alertMessage)
    }
  }
}

// MARK: - Preview

struct CommentView_Previews: PreviewProvider {
  static var previews: some View {
    FeedCommentView(communityId: 1, totalCommentCount: 10)
  }
}
