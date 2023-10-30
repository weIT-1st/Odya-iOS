//
//  FeedView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FeedView: View {
  // MARK: Properties
  
  @StateObject private var viewModel = FeedViewModel()
  
  // MARK: - Body

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        VStack(spacing: 0) {
          // tool bar
          // TODO: - 툴바 디자인 변경예정
          FeedToolBar()

          // scroll view
          ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
              // fishchips
              FishchipsBar()

              // posts (무한)
              ForEach(viewModel.state.content, id: \.communityID) { content in
                VStack(spacing: 0) {
                  PostImageView(urlString: content.communityMainImageURL)
                  NavigationLink {
                    FeedDetailView()
                  } label: {
                    PostContentView(
                      contentText: content.communityContent,
                      commentCount: content.communityCommentCount,
                      likeCount: content.communityLikeCount,
                      createDate: content.createdDate
                    )
                  }
                }
                .padding(.bottom, 8)
                .onAppear {
                  if viewModel.state.content.last == content {
                    viewModel.fetchNextPageIfPossible()
                  }
                }
              }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .refreshable {
            // fetch new posts
          }
          .onAppear {
            customRefreshControl()
          }
        }
        .background(Color.odya.background.normal)

        NavigationLink {
          
        } label: {
          WriteButton()
        }
        .padding(20)
      }  // ZStack
      .task {
        viewModel.fetchNextPageIfPossible()
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
}

// MARK: - Preview

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
