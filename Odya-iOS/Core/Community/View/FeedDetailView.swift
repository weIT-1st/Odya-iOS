//
//  FeedDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedDetailView: View {
  // MARK: Properties
  let testImageUrlString =
    "https://plus.unsplash.com/premium_photo-1680127400635-c3db2f499694?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60"

  @StateObject private var viewModel = FeedDetailViewModel()
  /// 탭뷰 사진 인덱스
  @State private var imageIndex: Int = 0
  /// 편집화면 토글
  @State private var showEditView = false
  /// 커뮤니티 아이디
  let communityId: Int
  /// 작성자
  let writer: Writer
  /// 작성일
  let createDate: String

  // MARK: Init

  init(communityId: Int, writer: Writer, createDate: String) {
    self.communityId = communityId
    self.writer = writer
    self.createDate = createDate
  }

  // MARK: Body

  var body: some View {
    ZStack(alignment: .top) {
      ScrollView(showsIndicators: false) {
        VStack(spacing: -16) {
          // images
          TabView(selection: $imageIndex) {
            if viewModel.feedDetail != nil {
              ForEach(0..<viewModel.feedDetail.communityContentImages.count, id: \.self) { index in
                VStack {
                  AsyncImage(
                    url: URL(string: viewModel.feedDetail.communityContentImages[index].imageURL)!,
                    content: { image in
                      image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.width
                        )
                        .clipped()
                    },
                    placeholder: {
                      ProgressView()
                    }
                  )
                }
                .tag(index)
              }
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .automatic))
          .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width)

          // -- content --
            // 탭뷰 가로 스크롤 잘 안돼서 스크롤뷰로 한번 더 묶음
            ScrollView {
                VStack(spacing: 8) {
                  VStack(spacing: 20) {
                    HStack(alignment: .center) {
                      FeedUserInfoView(
                        profileImageSize: ComponentSizeType.XS.ProfileImageSize, writer: writer,
                        createDate: createDate)

                      Spacer()

                      // 팔로우버튼
                      FollowButton(isFollowing: false, buttonStyle: .ghost) {
                        // follow
                      }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, GridLayout.side)

                    VStack(spacing: 24) {
                      // 여행일지
                      JournalCoverButton(
                        profileImageUrl: nil,
                        labelText: "여행일지 더보기",
                        coverImageUrl: URL(string: testImageUrlString)!,
                        journalTitle: "2020 컴공과 졸업여행",
                        isHot: true
                      ) {
                        // action
                      }

                      // feed text
                      Text(viewModel.feedDetail?.content ?? "")
                        .detail2Style()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, GridLayout.side)

                    VStack(spacing: 16) {
                      // tags
                      if viewModel.feedDetail?.topic != nil {
                        HStack(spacing: 8) {
                          FishchipButton(
                            isActive: .active, buttonStyle: .ghost, imageName: nil,
                            labelText: viewModel.feedDetail?.topic?.word ?? "",
                            labelSize: .S
                          ) {
                            // action
                          }
                        }
                        .padding(.horizontal, GridLayout.side)
                      }

                      // location, comment, heart button
                      HStack {
                        locationView
                        Spacer(minLength: 28)
                        HStack(spacing: 12) {
                          commentView
                          likeView
                        }
                      }
                      .frame(maxWidth: .infinity)
                      .padding(.horizontal, 18)
                      .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)

                    // -- comment --
                    FeedCommentView()
                  }
                  .background(Color.odya.background.normal)
                  .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))

                }  // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
      }  // ScrollView
      .edgesIgnoringSafeArea(.top)
      .toolbar(.hidden)

      // custom navigation bar
      navigationBar
    }
    .task {
      viewModel.fetchFeedDetail(id: communityId)
    }
    .fullScreenCover(isPresented: $showEditView) {
        CommunityComposeView(composeMode: .edit)
    }
  }

  private var navigationBar: some View {
    VStack {
      ZStack {
        CustomNavigationBar(title: "")
        HStack {
          Spacer()
          FeedMenuButton(showEditView: $showEditView, writerId: writer.userID)
        }
        .padding(.trailing, 12)
      }
    }
  }

  private var locationView: some View {
    HStack(spacing: 4) {
      Image("location-m")
        .renderingMode(.template)
        .foregroundColor(Color.odya.label.assistive)
        .frame(width: 24, height: 24)
      // 장소명
      Text("오이도오이도오이도오이도오이도오이도오이도")
        .lineLimit(1)
        .multilineTextAlignment(.leading)
        .detail2Style()
        .foregroundColor(Color.odya.label.assistive)
    }
  }

  private var commentView: some View {
    HStack(spacing: 4) {
      Image("comment")
        .frame(width: 24, height: 24)
      // number of comment
      Text("\(viewModel.feedDetail?.communityCommentCount ?? 0)")
        .detail1Style()
        .foregroundColor(Color.odya.label.normal)
    }
  }

  private var likeView: some View {
    HStack(spacing: 4) {
      Image("heart-off-m")
        .frame(width: 24, height: 24)
      // number of heart
      Text("\(viewModel.feedDetail?.communityLikeCount ?? 0)")
        .detail1Style()
        .foregroundColor(Color.odya.label.normal)
    }
  }
}

// MARK: - FeedShareButton

struct FeedMenuButton: View {
  @State private var showActionSheet = false
    
  @Binding var showEditView: Bool
    
  let writerId: Int

  var body: some View {
    IconButton("menu-kebab-l") {
      showActionSheet.toggle()
    }
    .frame(width: 36, height: 36, alignment: .center)
    .confirmationDialog("", isPresented: $showActionSheet) {
        /// 내가 작성한 글인 경우
        if writerId == MyData.userID {
            Button("편집") {
                // action: 편집
                showEditView.toggle()
            }
            Button("공유") {
                // action: 공유
            }
            Button("삭제", role: .destructive) {
                // action: 삭제
            }
        } else {
            // 타인의 글인 경우
            Button("공유") {
              // action: 공유
            }
            Button("신고하기", role: .destructive) {
              // action: 신고
            }
        }
    }
  }
}

// MARK: - Preview

struct FeedDetailView_Previews: PreviewProvider {
  static var previews: some View {
    FeedDetailView(
      communityId: 1,
      writer: Writer(
        userID: 1, nickname: "홍길동", profile: ProfileData(profileUrl: ""), isFollowing: false),
      createDate: "2023-10-30")
  }
}
