//
//  FeedDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedDetailView: View {
  // MARK: Properties
  @Environment(\.presentationMode) var presentationMode
  
  let testImageUrlString = "https://plus.unsplash.com/premium_photo-1680127400635-c3db2f499694?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60"
  
  @StateObject private var viewModel = FeedDetailViewModel()
  /// 탭뷰 사진 인덱스
  @State private var imageIndex: Int = 0
  /// 편집화면 토글
  @State private var showEditView = false
  /// 액션시트 토글
  @State private var showActionSheet = false
  /// 신고화면 토글
  @State private var showReportView = false
  /// 커뮤니티 아이디
  let communityId: Int
  
  // Comment
  @State private var commentCount: Int = 0
  
  // MARK: Init
  
  init(communityId: Int) {
    self.communityId = communityId
  }
  
  // MARK: Body
  
  var body: some View {
    ZStack(alignment: .top) {
      ScrollView(showsIndicators: false) {
        if viewModel.feedDetail != nil {
          VStack(spacing: -16) {
            // images
            TabView(selection: $imageIndex) {
              ForEach(0..<viewModel.feedDetail.communityContentImages.count, id: \.self) { index in
                VStack {
                  SquareAsyncImage(url: viewModel.feedDetail.communityContentImages[index].imageURL)
                }
                .tag(index)
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
                      profileImageSize: ComponentSizeType.XS,
                      writer: viewModel.feedDetail.writer,
                      createDate: viewModel.feedDetail.createdDate
                    )
                    
                    Spacer()
                    if viewModel.feedDetail.writer.userID != MyData.userID  {
                      // 팔로우버튼
                      let writer = viewModel.feedDetail.writer
                      FollowButtonWithAlertAndApi(userId: writer.userID, buttonStyle: .ghost, followState: writer.isFollowing ?? false)
                    }
                  }
                  .padding(.top, 16)
                  .padding(.horizontal, GridLayout.side)
                  
                  VStack(spacing: 24) {
                    // 여행일지 더보기
                    if let journal = viewModel.feedDetail.travelJournal {
                      NavigationLink {
                        TravelJournalDetailView(journalId: journal.travelJournalID, nickname: viewModel.feedDetail.writer.nickname)
                          .navigationBarHidden(true)
                      } label: {
                        ShowMoreJournalButton(
                          profile: nil,
                          labelText: "여행일지 더보기",
                          coverImageUrl: journal.mainImageURL,
                          journalTitle: journal.title
                        )
                      }
                    }

                    // feed text
                    Text(viewModel.feedDetail?.content ?? "")
                      .detail2Style()
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .multilineTextAlignment(.leading)
                  }
                  .padding(.horizontal, GridLayout.side)
                  
                  VStack(spacing: 16) {
                    // tag
                    if viewModel.feedDetail?.topic != nil {
                      tagView
                    }
                    
                    // location, comment, heart button
                    HStack {
                      locationView
                      Spacer(minLength: 28)
                      HStack(spacing: 12) {
                        CommunityLikeButton(
                          communityId: communityId,
                          likeState: viewModel.feedDetail.isUserLiked,
                          likeCount: viewModel.feedDetail.communityLikeCount,
                          baseColor: .odya.label.normal
                        )
                        commentView
                      }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                  }
                  .frame(maxWidth: .infinity)
                  
                  // -- comment --
                  FeedCommentView(communityId: communityId,
                                  totalCommentCount: viewModel.feedDetail.communityCommentCount)
                }
                .background(Color.odya.background.normal)
                .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
                
              }  // VStack
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
        } else {
          ProgressView()
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
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
      CommunityComposeView(
        communityId: viewModel.feedDetail.communityID,
        textContent: viewModel.feedDetail.content,
        privacyType: CommunityPrivacyType(rawValue: viewModel.feedDetail.visibility) ?? .global,
        travelJournalId: viewModel.feedDetail.travelJournal?.travelJournalID,
        travelJournalTitle: viewModel.feedDetail.travelJournal?.title,
        selectedTopicId: viewModel.feedDetail.topic?.id,
        originalImageList: viewModel.feedDetail.communityContentImages,
        showPhotoPicker: false,
        composeMode: .edit)
    }
    .fullScreenCover(isPresented: $showReportView) {
      ReportView(reportTarget: .community, id: communityId, isPresented: $showReportView)
    }
    .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
      Button {
        presentationMode.wrappedValue.dismiss()
      } label: {
        Text("닫기")
      }
    } message: {
      Text(viewModel.alertMessage)
    }
  }
  
  private var navigationBar: some View {
    VStack {
      ZStack {
        CustomNavigationBar(title: "")
        HStack {
          Spacer()
          feedMenuButton
        }
        .padding(.trailing, 12)
      }
    }
  }
  
  private var feedMenuButton: some View {
    IconButton("menu-kebab-l") {
      showActionSheet.toggle()
    }
    .frame(width: 36, height: 36, alignment: .center)
    .confirmationDialog("", isPresented: $showActionSheet) {
      if viewModel.feedDetail != nil {
        /// 내가 작성한 글인 경우
        if viewModel.feedDetail.writer.userID == MyData.userID {
          Button("편집") {
            // action: 편집
            showEditView.toggle()
          }
          Button("공유") {
            // action: 공유
          }
          Button("삭제", role: .destructive) {
            // action: 삭제
            viewModel.deleteCommunity(id: communityId)
          }
        } else {
          // 타인의 글인 경우
          Button("공유") {
            // action: 공유
          }
          Button("신고하기", role: .destructive) {
            // action: 신고
            showReportView.toggle()
          }
        }
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
      Text(commentCount > 99 ? "99+" : "\(commentCount)")
        .detail1Style()
        .foregroundColor(Color.odya.label.normal)
    }
    .onAppear {
      self.commentCount = viewModel.feedDetail.communityCommentCount
    }
  }
  
  private var tagView: some View {
    HStack(spacing: 8) {
      FishchipButton(
        isActive: .active, buttonStyle: .basic, imageName: nil,
        labelText: "# \(viewModel.feedDetail?.topic?.topic ?? "")",
        labelSize: .S
      ) {
        // action
      }
      Spacer()
    }
    .padding(.horizontal, GridLayout.side)
  }
}

// MARK: - Preview

struct FeedDetailView_Previews: PreviewProvider {
  static var previews: some View {
    FeedDetailView(communityId: 1)
  }
}
