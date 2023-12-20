//
//  MyCommunityActivityView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/14.
//

import SwiftUI

/// fishchip 버튼으로 보여줄 내 활동 선택하기 위한 옵션
enum MyCommunityActivityOptions: String, CaseIterable {
  case feed = "게시글"
  case comment = "댓글"
  case like = "좋아요"
}

/// 내 커뮤니티 활동 최상단 뷰
struct MyCommunityActivityView: View {
  // MARK: Properties
  /// 뷰모델
  @StateObject private var viewModel = MyCommunityActivityViewModel()
  /// 선택된 옵션(기본: 게시글)
  @State private var selectedOption: MyCommunityActivityOptions = .feed
  /// Grid columns
  var columns = [GridItem(.flexible(), spacing: 3),
                 GridItem(.flexible(), spacing: 3),
                 GridItem(.flexible())]
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(title: "내 활동")
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          description
          fishchips
          switch selectedOption {
          case .feed:
            // my feed grid
            LazyVGrid(columns: columns, spacing: 3) {
              ForEach(viewModel.feedState.content, id: \.communityID) { content in
                // 1:1 ratio image
                Color.clear.overlay(
                  AsyncImage(url: URL(string: content.communityMainImageURL)!) { phase in
                    switch phase {
                    case .success(let image):
                      image
                        .resizable()
                        .scaledToFill()
                    default:
                      ProgressView()
                    }
                  }
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .onAppear {
                  // 다음 페이지 불러오기
                  if content.communityID == viewModel.feedState.lastId {
                    viewModel.fetchMyFeedNextPageIfPossible()
                  }
                }
              }
            }
          case .comment:
            // my comments stack
            LazyVStack {
              ForEach(viewModel.commentState.content, id: \.communityID) { content in
                MyCommunityCommentCell(content: content)
                  .onAppear {
                    if content.communityID == viewModel.commentState.lastId {
                      viewModel.fetchMyCommentsNextPageIfPossible()
                    }
                  }
              }
            }
          case .like:
            // my likes grid
            LazyVGrid(columns: columns, spacing: 3) {
              ForEach(viewModel.likeState.content, id: \.communityID) { content in
                Color.clear.overlay(
                  AsyncImage(url: URL(string: content.communityMainImageURL)!) { phase in
                    switch phase {
                    case .success(let image):
                      image
                        .resizable()
                        .scaledToFill()
                    default:
                      ProgressView()
                    }
                  }
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipped()
                .onAppear {
                  // 다음 페이지 불러오기
                  if content.communityID == viewModel.likeState.lastId {
                    viewModel.fetchMyLikesNextPageIfPossible()
                  }
                }
              }
            }
          }
        }
        .padding(.horizontal, GridLayout.side)
        .task {
          viewModel.fetchMyFeedNextPageIfPossible()
          viewModel.fetchMyCommentsNextPageIfPossible()
          viewModel.fetchMyLikesNextPageIfPossible()
        }
        .background(Color.odya.background.normal)
      } // ScrollView
    }
    .toolbar(.hidden)
  }
  
  /// 설명글
  private var description: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("\(MyData().nickname)")
          .b1Style()
          .foregroundColor(.odya.brand.primary)
        Text(" 님의 모든 활동을")
          .b1Style()
          .foregroundColor(.odya.label.normal)
      }
      Text("한곳에서 관리해보세요")
        .b1Style()
        .foregroundColor(.odya.label.normal)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 27)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(16)
  }
  
  /// 게시글, 댓글, 좋아요 선택 fishchip button
  private var fishchips: some View {
    HStack(spacing: 10) {
      ForEach(MyCommunityActivityOptions.allCases, id: \.self) { option in
        FishchipButton(isActive: .active, buttonStyle: selectedOption == option ? .solid : .ghost, imageName: nil, labelText: option.rawValue, labelSize: .S) {
          // action
          selectedOption = option
        }
      }
      Spacer()
    }
  }
}

// MARK: - Previews
struct MyCommunityActivityView_Previews: PreviewProvider {
  static var previews: some View {
    MyCommunityActivityView()
  }
}
