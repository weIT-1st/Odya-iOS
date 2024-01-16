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
        VStack(spacing: 36) {
          HStack {
            Text("나의 여행일지")
              .h4Style()
              .foregroundColor(.odya.label.normal)
            Spacer()
          }
          noJournalView
        }
        VStack(spacing: 36) {
          HStack {
            Text("친구의 여행일지")
              .h4Style()
              .foregroundColor(.odya.label.normal)
            Spacer()
          }
          NoContentDescriptionView(title: "여행일지가 없어요.", withLogo: false)
        }
        VStack(spacing: 36) {
          HStack {
            Text("추천 여행일지")
              .h4Style()
              .foregroundColor(.odya.label.normal)
            Spacer()
          }
          NoContentDescriptionView(title: "여행일지가 없어요.", withLogo: false)
        }
      }
      .padding(.horizontal, GridLayout.side)
    }
  }
  
  private var noJournalView: some View {
    VStack(spacing: 24) {
      Image("noJournalImg")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 112, height: 70)
      Text("작성된 여행일지가 없어요!")
        .h6Style()
        .foregroundColor(.odya.label.normal)
      CTAButton(isActive: .active, buttonStyle: .solid, labelText: "여행일지 작성하러가기", labelSize: .L) {
        // compose travel journal
      }
    }
    .padding(.vertical, 24)
    .padding(.horizontal, 10)
    .background(Color.odya.elevation.elev3)
    .cornerRadius(16)
  }
  
  // MARK: - Review
  var reviewPart: some View {
    VStack(spacing: 28) {
      PlaceDetailContentTypeSelection(contentType: .review, destination: $scrollDestination, isDestinationChanged: $isScrollDestinationChanged)
      
      VStack(spacing: 24) {
        VStack(spacing: 36) {
          HStack {
            HStack(spacing: 8) {
              Text("한줄리뷰")
                .h5Style()
                .foregroundColor(.odya.label.normal)
              Text(String(format: "%.1f", viewModel.averageStarRating))
                .b2Style()
                .foregroundColor(.odya.label.assistive)
            }
            Spacer()
            HStack(spacing: 8) {
              Text("리뷰 총")
                .b1Style()
                .foregroundColor(.odya.label.normal)
              HStack(spacing: 4) {
                Text("\(viewModel.reviewCount ?? 0)")
                  .b2Style()
                  .foregroundColor(.odya.brand.primary)
                Text("개")
                  .b1Style()
                  .foregroundColor(.odya.label.normal)
              }
            }
          }
          .padding(.horizontal, GridLayout.side)
          StarRatingView(rating: $viewModel.averageStarRating, size: .M)
            .disabled(true)
        } // header
        
        if let isReviewExisted = viewModel.isReviewExisted {
          if !isReviewExisted {
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
        }
        // TODO: 정렬
        
        // list
        if viewModel.reviewState.content.isEmpty {
          NoContentDescriptionView(title: "아직 리뷰가 없어요.", withLogo: true)
            .frame(height: 280)
        } else {
          // TODO: 더보기, 무한스크롤?
          VStack(spacing: 16) {
            if let myReview = viewModel.myReview {
              PlaceReviewCell(review: myReview)
            }
            ForEach(viewModel.reviewState.content, id: \.reviewId) { review in
              if review.writer.userID != MyData.userID {
                PlaceReviewCell(review: review)
              }
            }
          }
        }
      }
    }
  }
  
  // MARK: - Community
  var communityPart: some View {
    VStack(spacing: 28) {
      PlaceDetailContentTypeSelection(contentType: .community, destination: $scrollDestination, isDestinationChanged: $isScrollDestinationChanged)
      
      if viewModel.feedState.content.isEmpty {
        NoContentDescriptionView(title: "아직 게시물이 없어요.", withLogo: true)
          .frame(height: 320)
      } else {
        LazyVGrid(columns: columns, spacing: 3) {
          ForEach(viewModel.feedState.content, id: \.communityID) { content in
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
              if content.communityID == viewModel.feedState.lastId {
                viewModel.fetchAllFeedByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
              }
            }
          }
        }
      }
    }
  }
}
