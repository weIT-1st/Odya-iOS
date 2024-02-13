//
//  FeedView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

enum FeedRoute: Hashable {
  case detail(Int)
  case createFeed
  case createJournal
  case activity
  case notification
  case journalDetail(Int)
}

enum FeedToggleType {
  case all
  case friend
}

struct FeedView: View {
  // MARK: Properties

  @StateObject private var viewModel = FeedViewModel()
  @StateObject var followHubVM = FollowHubViewModel()
  
  @State private var selectedFeedToggle = FeedToggleType.all
  /// 선택된 토픽 아이디
  @State private var selectedTopicId = -1
  /// 검색뷰 토글
  @State private var showSearchView = false
  @State private var path = NavigationPath()
  
  // MARK: - Body

  var body: some View {
    NavigationStack(path: $path) {
      GeometryReader { _ in
        ZStack(alignment: .bottomTrailing) {
          VStack(spacing: 0) {
            // tool bar
            feedToolBar

            ScrollView(.vertical, showsIndicators: false) {
              LazyVStack(spacing: 4) {
                // fishchips
                if selectedFeedToggle == .all {
                  FishchipsBar(selectedTopicId: $selectedTopicId)
                    .padding(.bottom, -4)
                    .zIndex(2)
                }
                // toggle
                feedToggleSelectionView
                  .zIndex(.greatestFiniteMagnitude)
                
                // posts (무한)
                ForEach(Array(zip(viewModel.state.content, viewModel.state.content.indices)), id: \.0.id) { content, index in
                  LazyVStack(spacing: 8) {
                    VStack(spacing: 0) {
                      postImageView(imageUrl: content.communityMainImageURL, simpleTravelJournal: content.travelJournalSimpleResponse)
                      PostContentView(post: content)
                    }

                    // 알 수도 있는 친구
                    if index % 10 == 0 && index > 0 {
                      userSuggestion
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
          
          // 피드 작성하기
          NavigationLink(value: FeedRoute.createFeed) {
            WriteButton()
          }
          .padding(20)
          
          if showSearchView {
            FeedUserSearchView(isPresented: $showSearchView)
          }
        }  // ZStack
        .toolbar(.hidden)
        .navigationDestination(for: FeedRoute.self) { route in
          switch route {
          case let .detail(communityId):
            FeedDetailView(path: $path, communityId: communityId)
          case .createFeed:
            CommunityComposeView(path: $path)
          case .createJournal:
            TravelJournalComposeView()
              .navigationBarHidden(true)
          case .activity:
            MyCommunityActivityView()
          case .notification:
            FeedNotificationView()
          case let .journalDetail(journalId):
            TravelJournalDetailView(journalId: journalId)
              .navigationBarHidden(true)
          }
        }
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
      NavigationLink(value: FeedRoute.activity) {
        ProfileImageView(of: MyData.nickname, profileData: MyData.profile.decodeToProileData(), size: .S)
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
      NavigationLink(value: FeedRoute.notification) {
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
  
  /// 알 수도 있는 친구
  private var userSuggestion: some View {
    UserSuggestionView()
      .environmentObject(followHubVM)
  }
  
  /// 게시글 이미지, 연결된 여행일지
  func postImageView(imageUrl: String, simpleTravelJournal: TravelJournalSimpleResponse?) -> some View {
    ZStack(alignment: .bottom) {
      // image
      AsyncImage(
        url: URL(string: imageUrl)!,
        content: { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
              // 화면 너비와 같음
              width: UIScreen.main.bounds.width,
              height: UIScreen.main.bounds.width
            )
            .clipped()
        },
        placeholder: {
          ProgressView()
            .frame(
              width: UIScreen.main.bounds.width,
              height: UIScreen.main.bounds.width
            )
        }
      )

      // 여행일지 연동
      if let journal = simpleTravelJournal {
        NavigationLink(value: FeedRoute.journalDetail(journal.travelJournalId)) {
          HStack {
            Image("diary")
              .frame(width: 24, height: 24)
            Text(journal.title)
              .detail1Style()
              .foregroundColor(.odya.label.normal)
            Spacer()
            Image("direction-right")
          }
          .padding(.leading, 17)
          .padding(.trailing, 13)
          .frame(maxWidth: .infinity)
          .frame(height: 50)
          .background(Color.odya.background.dimmed_system)
          .clipShape(RoundedEdgeShape(edgeType: .top))
        }
      }
    }
    .clipShape(RoundedEdgeShape(edgeType: .top))
  }
}

// MARK: - Preview

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
