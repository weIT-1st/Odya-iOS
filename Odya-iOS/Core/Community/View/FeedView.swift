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
  /// 검색뷰 토글
  @State private var showSearchView = false
  
  // MARK: - Body

  var body: some View {
    NavigationView {
      GeometryReader { _ in
        ZStack(alignment: .bottomTrailing) {
          VStack(spacing: 0) {
            // tool bar
            feedToolBar

            ScrollView(.vertical, showsIndicators: false) {
              // fishchips
              if selectedFeedToggle == .all {
                FishchipsBar(selectedTopicId: $selectedTopicId)
                  .padding(.bottom, -4)
              }
              // toggle
              feedToggleSelectionView
                .zIndex(.greatestFiniteMagnitude)

              LazyVStack(spacing: 4) {
                // posts (무한)
                ForEach(viewModel.state.content, id: \.communityID) { content in
                  VStack(spacing: 0) {
                    PostImageView(urlString: content.communityMainImageURL)
                    NavigationLink {
                      FeedDetailView(communityId: content.communityID)
                    } label: {
                      PostContentView(
                        communityId: content.communityID,
                        contentText: content.communityContent,
                        commentCount: content.communityCommentCount,
                        likeCount: content.communityLikeCount,
                        createDate: content.createdDate,
                        writer: content.writer,
                        isUserLiked: content.isUserLiked
                      )
                    }
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
                  .padding(.bottom, 8)
                }
              }
            }  // ScrollView
            .zIndex(0)
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
            .task {
              if viewModel.state.content.isEmpty {
                viewModel.fetchAllFeedNextPageIfPossible()
              }
            }
          }
          .background(Color.odya.background.normal)

          NavigationLink(destination: CommunityComposeView(composeMode: .create), label: {
            WriteButton()
          })
          .padding(20)
          
          if showSearchView {
            FeedUserSearchView(isPresented: $showSearchView)
          }
        }  // ZStack
        .toolbar(.hidden)
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
  
  /// 툴바
  private var feedToolBar: some View {
    HStack(alignment: .center) {
      // 내 커뮤니티 활동 뷰로 연결
      NavigationLink {
        MyCommunityActivityView()
      } label: {
        ProfileImageView(profileUrl: MyData().profile, size: .S)
          .overlay(
            RoundedRectangle(cornerRadius: 32)
              .inset(by: 0.5)
              .stroke(Color.odya.brand.primary, lineWidth: 1)
          )
      }
      .frame(width: 48, height: 48, alignment: .center)
      .padding(.leading, 13)

      Spacer()

      // search icon
      Button {
        showSearchView.toggle()
      } label: {
        Image("search")
          .padding(10)
          .frame(width: 48, height: 48, alignment: .center)
      }

      // alarm on/off
      Button {
        // action: show alarm
      } label: {
        Image("alarm-on")
          .padding(10)
          .frame(width: 48, height: 48, alignment: .center)
      }
    }  // HStack
    .frame(height: 56)
  }

  /// 토글: 전체글보기, 친구글보기
  private var feedToggleSelectionView: some View {
    HStack(alignment: .center, spacing: 16) {
      Spacer()
      Button {
        selectedFeedToggle = .all
        viewModel.refreshAllFeed()
      } label: {
        HStack(alignment: .center, spacing: 4) {
          Circle().frame(width: 4, height: 4)
          Text("전체 보기")
            .detail1Style()
            .frame(height: 24)
        }
        .foregroundColor(
          selectedFeedToggle == .all ? Color.odya.brand.primary : Color.odya.label.inactive
        )
      }

      Button {
        selectedFeedToggle = .friend
        viewModel.refreshFriendFeed()
      } label: {
        HStack(alignment: .center, spacing: 4) {
          Circle().frame(width: 4, height: 4)
          Text("친구글만 보기")
            .detail1Style()
            .frame(height: 24)
        }
        .foregroundColor(
          selectedFeedToggle == .friend ? Color.odya.brand.primary : Color.odya.label.inactive
        )
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, GridLayout.side)
    .padding(.bottom, 8)
  }
}

// MARK: - Preview

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
