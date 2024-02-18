//
//  FeedFullCommentSheet.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/21.
//

import SwiftUI

struct FeedFullCommentSheet: View {
  // MARK: Properties
  
  enum FocusField: Hashable {
    case comment
  }
  
  @EnvironmentObject var viewModel: CommentViewModel
  @FocusState private var focusedField: FocusField?
  
  let isEditing: Bool
  let communityId: Int
  
  // MARK: Init
  
  init(isEditing: Bool, communityId: Int) {
    self.isEditing = isEditing
    self.communityId = communityId
  }

  // MARK: Body
  
  var body: some View {
    VStack(spacing: 0) {
      VStack {
        ScrollView {
          VStack(spacing: 16) {
            ForEach(viewModel.state.content, id: \.communityCommentID) { content in
              FeedCommentCell(communityId: communityId, content: content)
                .environmentObject(viewModel)
                .onAppear {
                  // 마지막 댓글일때 다음 댓글 가져오기
                  if content.communityCommentID == viewModel.state.content.last?.communityCommentID {
                    viewModel.fetchCommentNextPageIfPossible(communityId: communityId)
                  }
                }
              Divider()
            }
          }
          .padding(.horizontal, GridLayout.side)
        }

        Spacer()

        // 댓글 입력
        commentTextField
      }
      .padding(.vertical, 24)
      .padding(.horizontal, GridLayout.side)
      .onAppear {
        if isEditing || viewModel.isUpdatingComment {
          self.focusedField = .comment
        }
      }
    }
    .padding(.top, 24) // 인디케이터와 간격
  }
  
  /// 댓글 입력 텍스트필드
  private var commentTextField: some View {
    HStack(alignment: .center, spacing: 16) {
      ProfileImageView(of: MyData.nickname,
                       profileData: MyData.profile.decodeToProileData(),
                       size: ComponentSizeType.XS)

      TextField("댓글을 입력해주세요", text: $viewModel.newCommentText)
        .focused($focusedField, equals: .comment)

      Spacer()
      
      Button {
        // action: 댓글 생성 or 수정
        if viewModel.isUpdatingComment {
          viewModel.patchComment(communityId: communityId)
        } else {
          viewModel.createComment(communityId: communityId)
        }
      } label: {
        Image("smallGreyButton-send")
          .renderingMode(.template)
          .foregroundColor(Color.odya.label.assistive)
          .frame(width: 24, height: 24)
      }
      .disabled(viewModel.newCommentText.isEmpty || viewModel.isProcessing)
    }
    .frame(height: 48)
    .padding(.horizontal, 16)
    .padding(.vertical, 4)
    .background(Color.odya.elevation.elev5)
    .cornerRadius(Radius.medium)
  }
}

// MARK: - Preview
struct FeedFullCommentSheet_Previews: PreviewProvider {
  static var previews: some View {
    FeedFullCommentSheet(isEditing: false, communityId: 1)
  }
}
