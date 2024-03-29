//
//  PlaceReviewCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/15.
//

import SwiftUI

struct PlaceReviewCell: View {
  let review: Review
  let starRating: Double
  let isMyReview: Bool
  
  @EnvironmentObject var viewModel: ReviewViewModel
  @State private var showUserProfile: Bool = false
  @State private var showReviewEidtView: Bool = false
  @State private var showReportView: Bool = false
  
  init(review: Review) {
    self.review = review
    self.starRating = Double(review.starRating) / 2
    self.isMyReview = review.writer.userID == MyData.userID
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Button {
        showUserProfile.toggle()
      } label: {
        ProfileImageView(of: "", profileData: review.writer.profile, size: .S)
      }
      .disabled(isMyReview)
      .fullScreenCover(isPresented: $showUserProfile) {
        let writer = review.writer
        ProfileView(userId: writer.userID,
                    nickname: writer.nickname,
                    profileUrl: writer.profile.profileUrl,
                    isFollowing: writer.isFollowing ?? false)
      }
      VStack(alignment: .leading, spacing: 8) {
        if isMyReview {
          HStack {
            Text("내가 작성한 리뷰")
              .detail1Style()
              .foregroundColor(.odya.brand.primary)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(Color.clear)
              .overlay(
                RoundedEdgeShape(edgeType: .bubble, cornerRadius: 12)
                  .stroke(Color.odya.brand.primary, lineWidth: 1)
              )
            Spacer()
          }
        }
        VStack(alignment: .trailing, spacing: 8) {
          VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
              Text(review.writer.nickname)
                .h6Style()
                .foregroundColor(isMyReview ? .odya.label.r_normal : .odya.label.normal)
              StarRatingView(rating: .constant(starRating), size: .S, isMyReview: isMyReview)
              Spacer()
              Menu {
                if isMyReview {
                  Button("리뷰 수정") {
                    showReviewEidtView.toggle()
                  }
                  Button("리뷰 삭제") {
                    viewModel.deleteReview(reviewId: review.reviewId)
                  }
                } else {
                  Button("신고하기") {
                    print("신고하기 눌림!!")
                    showReportView.toggle()
                  }
                }
              } label: {
                Image("menu-kebob")
                  .renderingMode(.template)
                  .foregroundColor(isMyReview ? .odya.label.r_normal : .odya.label.normal)
              }
            }
            Text(review.review)
              .detail2Style()
              .foregroundColor(isMyReview ? .odya.label.r_normal : .odya.label.assistive)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          Text(review.createdAtDate.dateToString(format: "yyyy.MM.dd"))
            .detail2Style()
            .foregroundColor(.odya.label.r_assistive)
        }
        .padding(.vertical, 12)
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .background(isMyReview ? Color.odya.brand.primary : Color.odya.elevation.elev2)
        .cornerRadius(Radius.medium)
      }
    }
    .padding(.horizontal, GridLayout.side)
    .padding(.vertical, isMyReview ? 10 : 0)
    .background(isMyReview ? Color.odya.elevation.elev4 : Color.clear)
    .fullScreenCover(isPresented: $showReportView) {
      ReportView(reportTarget: .placeReview,
                 id: review.reviewId,
                 isPresented: $showReportView)
    }
    .sheet(isPresented: $showReviewEidtView) {
      ReviewComposeView(isPresented: $showReportView,
                        placeId: .constant(review.placeId),
                        reviewId: review.reviewId,
                        reviewText: review.review, rating: Double(review.starRating) / 2)
        .environmentObject(viewModel)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }
}

struct PlaceReviewCell_Previews: PreviewProvider {
  static var previews: some View {
    PlaceReviewCell(review: Review(reviewId: 1, placeId: "", writer: Writer(userID: 121, nickname: "홍길동", profile: ProfileData(profileUrl: "1234"), isFollowing: false), starRating: 7, review: "노을뷰가 너무 예뻐요~노을뷰가 너무 예뻐요~노을뷰가 너무 예뻐요~", createdAt: ""))
  }
}
