//
//  PlaceReviewCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/15.
//

import SwiftUI

struct PlaceReviewCell: View {
  let review: Review
  let starRateing: Double
  let isMyReview: Bool
  
  init(review: Review) {
    self.review = review
    self.starRateing = Double(review.starRating) / 2
    self.isMyReview = review.writer.userID == 121
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // profile s
      ProfileImageView(of: "", profileData: review.writer.profile, size: .S)
      VStack(alignment: .leading, spacing: 8) {
        if isMyReview {
          HStack {
            Text("내가 작성한 리뷰")
              .detail1Style()
              .foregroundColor(.odya.brand.primary)
              .padding(8)
              .cornerRadius(12)
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .inset(by: 0.5)
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
              smallStarRatingView
              Spacer()
              Button {
                
              } label: {
                Image("menu-kebob")
                  .renderingMode(.template)
                  .foregroundColor(isMyReview ? .odya.label.r_normal : .odya.label.normal)
              }
            }
            Text(review.review)
              .detail2Style()
              .foregroundColor(isMyReview ? .odya.label.r_normal : .odya.label.assistive)
          }
          Text(review.createdAt)
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
  }
  
  private let minimumRating: Double = 0.0
  private let maximumRating: Double = 5.0
  private let spacing: CGFloat = 1
  private let starWidth: CGFloat = 17
  
  private var smallStarRatingView: some View {
    HStack(spacing: spacing) {
      ForEach(0..<Int(starRateing), id: \.self) { _ in
        filledStarImage
      }
      if starRateing != round(starRateing) {
        halfStarImage
      }
      ForEach(0..<Int(maximumRating - starRateing), id: \.self) { _ in
        emptyStarImage
      }
    }
  }
  
  private var filledStarImage: some View {
    VStack {
      if isMyReview {
        Image("star-on")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.odya.label.r_normal)
          .frame(width: starWidth, height: starWidth)
      } else {
        Image("star-yellow")
          .resizable()
          .frame(width: starWidth, height: starWidth)
      }
    }
  }
  
  private var halfStarImage: some View {
    HStack(spacing: 0) {
      if isMyReview {
        Image("star-on")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.odya.label.r_normal)
          .scaledToFill()
          .frame(width: starWidth / 2, height: starWidth, alignment: .leading)
          .clipped()
        Image("star-off")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.odya.label.r_normal)
          .scaledToFill()
          .frame(width: starWidth / 2, height: starWidth, alignment: .trailing)
          .clipped()
      } else {
        Image("star-yellow")
          .resizable()
          .scaledToFill()
          .frame(width: starWidth / 2, height: starWidth, alignment: .leading)
          .clipped()
        Image("star-off")
          .resizable()
          .scaledToFill()
          .frame(width: starWidth / 2, height: starWidth, alignment: .trailing)
          .clipped()
      }
    }
    .frame(width: starWidth)
  }
  
  private var emptyStarImage: some View {
    VStack {
      if isMyReview {
        Image("star-off")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.odya.label.r_normal)
          .frame(width: starWidth, height: starWidth)
      } else {
        Image("star-off")
          .resizable()
          .frame(width: starWidth, height: starWidth)
      }
    }
  }
}

struct PlaceReviewCell_Previews: PreviewProvider {
  static var previews: some View {
    PlaceReviewCell(review: Review(reviewId: 1, placeId: "", writer: Writer(userID: 121, nickname: "홍길동", profile: ProfileData(profileUrl: "1234"), isFollowing: false), starRating: 7, review: "노을뷰가 너무 예뻐요~노을뷰가 너무 예뻐요~노을뷰가 너무 예뻐요~", createdAt: "2024-01-08T10:33:19"))
  }
}
