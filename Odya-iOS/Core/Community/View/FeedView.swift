//
//  FeedView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

enum FeedToggleType {
  case all
  case friend
}

struct FeedView: View {
  // MARK: Properties

  @StateObject private var viewModel = FeedViewModel()
  @State private var selectedFeedToggle = FeedToggleType.all
  /// 선택된 토픽 아이디
  @State private var selectedTopicId = -1

  // MARK: - Body

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        VStack(spacing: 0) {
          // tool bar
          // TODO: - 툴바 디자인 변경예정
          FeedToolBar()

          ScrollView(showsIndicators: false) {
            // fishchips
            if selectedFeedToggle == .all {
              FishchipsBar(selectedTopicId: $selectedTopicId)
            }
            // toggle
            feedToggleSelectionView

            ScrollView {
              LazyVStack(spacing: 4) {
                // posts (무한)
                ForEach(viewModel.state.content, id: \.communityID) { content in
                  VStack(spacing: 0) {
                    PostImageView(urlString: content.communityMainImageURL)
                    NavigationLink {
                      FeedDetailView(communityId: content.communityID)
                    } label: {
                      PostContentView(
                        contentText: content.communityContent,
                        commentCount: content.communityCommentCount,
                        likeCount: content.communityLikeCount,
                        createDate: content.createdDate,
                        writer: content.writer
                      )
                    }
                  }
                  .padding(.bottom, 8)
                  .onAppear {
                    if viewModel.state.content.last == content {
                      switch selectedFeedToggle {
                      case .all:
                        if selectedTopicId > 0 {
                          // 선택된 토픽이 있는 경우
                          viewModel.fetchTopicFeedNextPageIfPossible(topicId: selectedTopicId)
                        } else {
                          // 없는경우(전체 조회)
                          viewModel.fetchAllFeedNextPageIfPossible()
                        }
                      case .friend:
                        viewModel.fetchFriendFeedNextPageIfPossible()
                      }
                    }
                  }
                }
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }  // ScrollView
          .refreshable {
            switch selectedFeedToggle {
            case .all:
              if selectedTopicId > 0 {
                viewModel.refreshTopicFeed(topicId: selectedTopicId)
              } else {
                viewModel.refreshAllFeed()
              }
            case .friend:
              viewModel.refreshFriendFeed()
            }
          }
          .onAppear {
            customRefreshControl()
          }
          .onChange(of: selectedTopicId) { newValue in
            if newValue > 0 {
              viewModel.refreshTopicFeed(topicId: selectedTopicId)
            } else if newValue == -1 {
              viewModel.refreshAllFeed()
            }
          }
        }
        .background(Color.odya.background.normal)

        NavigationLink(destination: CommunityComposeView(composeMode: .create), label: {
          WriteButton()
        })
        .padding(20)
      }  // ZStack
      .task {
        viewModel.fetchAllFeedNextPageIfPossible()
      }
    }
  }

  /// 새로고침 뷰 커스텀
  func customRefreshControl() {
    UIRefreshControl.appearance().tintColor = .clear
    UIRefreshControl.appearance().backgroundColor = UIColor(Color.odya.brand.primary)
    let attribute = [
      NSAttributedString.Key.foregroundColor: UIColor(Color.odya.label.r_assistive),
      NSAttributedString.Key.font: UIFont(name: "KIMM_Bold", size: 16),
    ]
    UIRefreshControl.appearance().attributedTitle = NSAttributedString(
      string: "피드에 올린 곳 오댜?", attributes: attribute as [NSAttributedString.Key: Any])
  }

  /// 토글: 전체글보기, 친구글보기
  private var feedToggleSelectionView: some View {
    HStack(spacing: 16) {
      Spacer()
      Button {
        selectedFeedToggle = .all
        viewModel.refreshAllFeed()
      } label: {
        HStack(spacing: 4) {
          Circle().frame(width: 4, height: 4)
          Text("전체 보기")
            .detail1Style()
        }
        .foregroundColor(
          selectedFeedToggle == .all ? Color.odya.brand.primary : Color.odya.label.inactive
        )
        .padding(.bottom, 12)
      }

      Button {
        selectedFeedToggle = .friend
        viewModel.refreshFriendFeed()
      } label: {
        HStack(spacing: 4) {
          Circle().frame(width: 4, height: 4)
          Text("친구글만 보기")
            .detail1Style()
        }
        .foregroundColor(
          selectedFeedToggle == .friend ? Color.odya.brand.primary : Color.odya.label.inactive
        )
        .padding(.bottom, 12)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, GridLayout.side)
  }
}

// MARK: - Preview

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
