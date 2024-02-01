//
//  Extension+PlaceDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/09.
//

import SwiftUI

extension PlaceDetailView {
  // MARK: - TravelJournal
  var travelJournalPart: some View {
    VStack(spacing: 28) {
      PlaceDetailContentTypeSelection(contentType: .journal, destination: $scrollDestination, isDestinationChanged: $isScrollDestinationChanged)
      VStack(spacing: 48) {
        VStack(spacing: 32) {
          journalTypeTitle(title: "나의 여행일지")
          if let myJournal = placeDetailVM.myJournalList.first {
            NavigationLink(value: PlaceDetailRoute.journalDetail(id: myJournal.journalId)) {
              MyPlaceJournalCardView(placeId: placeInfo.placeId, myJournal: myJournal, coordinates: $placeDetailVM.myJournalImageCoordinate)
            }
          } else {
            NoJournalCardView()
          }
        }
        VStack(spacing: 32) {
          journalTypeTitle(title: "친구의 여행일지")
          if placeDetailVM.friendsJournalState.content.isEmpty {
            NoContentDescriptionView(title: "여행일지가 없어요.", withLogo: false)
          } else {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 8) {
                ForEach(placeDetailVM.friendsJournalState.content, id: \.id) { content in
                  // TODO: navigation
                  NavigationLink(value: PlaceDetailRoute.journalDetail(id: content.journalId)) {
                    friendsJournalCell(content: content)
                      .onAppear {
                        if content.journalId == placeDetailVM.friendsJournalState.lastId {
                          placeDetailVM.fetchFriendsTravelJournalByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
                        }
                      }
                  }
                }
              }
            }
          }
        }
        VStack(spacing: 32) {
          journalTypeTitle(title: "추천 여행일지")
          if placeDetailVM.recommendedJournalState.content.isEmpty {
            NoContentDescriptionView(title: "여행일지가 없어요.", withLogo: false)
          } else {
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 8) {
                ForEach(placeDetailVM.recommendedJournalState.content, id: \.id) { content in
                  NavigationLink(value: PlaceDetailRoute.journalDetail(id: content.journalId)) {
                    recommendJournalCell(url: content.imageUrl)
                      .onAppear {
                        if content.journalId == placeDetailVM.recommendedJournalState.lastId {
                          placeDetailVM.fetchRecommendedTravelJournalByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
                        }
                      }
                  }
                }
              }
            }
          }
        }
      }
      .padding(.horizontal, GridLayout.side)
    }
  }
  
  private func journalTypeTitle(title: String) -> some View {
    HStack {
      Text(title)
        .h4Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
    }
  }
  
  private func friendsJournalCell(content: TravelJournalData) -> some View {
    VStack(alignment: .leading) {
      Text(content.title)
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      HStack {
        HStack(spacing: 8) {
          ProfileImageView(profileUrl: content.writer.profile.profileUrl, size: .S)
          Text(content.writer.nickname)
            .b1Style()
            .foregroundColor(.odya.label.normal)
            .lineLimit(1)
        }
        Spacer()
        Text(content.travelStartDate.dateToString(format: "yyyy.MM.dd"))
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
      }
    }
    .padding(16)
    .frame(width: 232, height: 200, alignment: .leading)
    .background(
      AsyncImage(url: URL(string: content.imageUrl)!) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 232, height: 200)
          .clipped()
      } placeholder: {
        Color.odya.background.dimmed_system
          .frame(width: 232, height: 200)
      }
    )
    .cornerRadius(Radius.medium)
  }
  
  private func recommendJournalCell(url: String) -> some View {
    AsyncImage(url: URL(string: url)!) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 141, height: 83)
        .cornerRadius(Radius.medium)
        .clipped()
    } placeholder: {
      ProgressView()
        .frame(width: 141, height: 83)
    }
  }
  
  // MARK: - Review
  var reviewPart: some View {
    VStack(spacing: 28) {
      PlaceDetailContentTypeSelection(contentType: .review, destination: $scrollDestination, isDestinationChanged: $isScrollDestinationChanged)
      
      VStack(spacing: 12) {
        VStack(spacing: 24) {
          VStack(spacing: 36) {
            reviewHeader
            StarRatingView(rating: .constant(reviewVM.averageStarRating), size: .M)
              .disabled(true)
          } // header
          
          if let isReviewExisted = reviewVM.isReviewExisted {
            if !isReviewExisted {
              newReviewTrigger
            }
          }
          reviewSortMenu
        }
        // list
        if reviewVM.reviewState.content.isEmpty {
          NoContentDescriptionView(title: "아직 리뷰가 없어요.", withLogo: true)
            .frame(height: 280)
        } else {
          VStack(spacing: 16) {
            if let myReview = reviewVM.myReview {
              PlaceReviewCell(review: myReview)
                .environmentObject(reviewVM)
            }
            ForEach(reviewVM.reviewState.content.prefix(maxReviewCount), id: \.reviewId) { review in
              if review.writer.userID != MyData.userID {
                PlaceReviewCell(review: review)
              }
            }
            // 더보기
            if let totalCount = reviewVM.reviewCount {
              if totalCount > maxReviewCount {
                ShowMoreButton(labelText: "\(totalCount - reviewVM.reviewState.content.prefix(maxReviewCount).count)개의 리뷰 더보기") {
                  showFullReviewBottomSheet.toggle()
                }
                .padding(.horizontal, GridLayout.side)
              }
            }
          }
        }
      }
    } // VStack
    .onChange(of: reviewVM.needToRefresh) { _ in
      reviewVM.refreshAllReviewContent(placeId: placeInfo.placeId, sortType: selectedReviewSortType.sortType)
    }
    .sheet(isPresented: $showFullReviewBottomSheet) {
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack {
          ForEach(reviewVM.reviewState.content, id: \.id) { review in
            PlaceReviewCell(review: review)
              .onAppear {
                if review.reviewId == reviewVM.reviewState.lastId {
                  reviewVM.fetchReviewByPlaceNextPageIfPossible(placeId: placeInfo.placeId, sortType: selectedReviewSortType.sortType)
                }
              }
          }
        }
        .padding(.vertical, 36)
      }
      .background(Color.odya.background.normal)
      .presentationDetents([.medium, .large])
    }
  }
  
  private var reviewHeader: some View {
    HStack {
      HStack(spacing: 8) {
        Text("한줄리뷰")
          .h5Style()
          .foregroundColor(.odya.label.normal)
        Text(String(format: "%.1f", reviewVM.averageStarRating))
          .b2Style()
          .foregroundColor(.odya.label.assistive)
      }
      Spacer()
      HStack(spacing: 8) {
        Text("리뷰 총")
          .b1Style()
          .foregroundColor(.odya.label.normal)
        HStack(spacing: 4) {
          Text("\(reviewVM.reviewCount ?? 0)")
            .b2Style()
            .foregroundColor(.odya.brand.primary)
          Text("개")
            .b1Style()
            .foregroundColor(.odya.label.normal)
        }
      }
    }
    .padding(.horizontal, GridLayout.side)
  }
  
  private var reviewSortMenu: some View {
    HStack(spacing: 8) {
      Spacer()
      Menu {
        ForEach(ReviewSortType.allCases, id: \.self) { item in
          if item != selectedReviewSortType {
            Button(item.title) {
              selectedReviewSortType = item
              reviewVM.sortReivew(placeId: placeInfo.placeId, sortType: selectedReviewSortType.sortType)
            }
          }
        }
      } label: {
        Text(selectedReviewSortType.title)
          .detail2Style()
          .foregroundColor(.odya.label.normal)
        Image("direction-down")
      }
    }
    .padding(.horizontal, 25)
  }
  
  private var newReviewTrigger: some View {
    VStack(spacing: 16) {
      Text("\(placeInfo.title)의 방문 경험은 어떠셨나요?")
        .detail2Style()
        .foregroundColor(.odya.label.normal)
      CTAButton(isActive: .active, buttonStyle: .ghost, labelText: "리뷰 작성", labelSize: .L) {
        showReviewComposeView.toggle()
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 24)
    .frame(maxWidth: .infinity)
    .background(Color.odya.elevation.elev4)
  }
  
  // MARK: - Community
  var communityPart: some View {
    VStack(spacing: 28) {
      PlaceDetailContentTypeSelection(contentType: .community, destination: $scrollDestination, isDestinationChanged: $isScrollDestinationChanged)
      
      if placeDetailVM.feedState.content.isEmpty {
        NoContentDescriptionView(title: "아직 게시물이 없어요.", withLogo: true)
          .frame(height: 320)
      } else {
        LazyVGrid(columns: columns, spacing: 3) {
          ForEach(placeDetailVM.feedState.content, id: \.communityID) { content in
            NavigationLink(value: PlaceDetailRoute.feedDetail(id: content.communityID)) {
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
            }
            .task {
              // 다음 페이지 불러오기
              if content.communityID == placeDetailVM.feedState.lastId {
                placeDetailVM.fetchAllFeedByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
              }
            }
          }
        }
      }
    }
  }
}
