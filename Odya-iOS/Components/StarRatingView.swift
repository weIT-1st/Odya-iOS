//
//  StarRatingView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import SwiftUI

/// 별점 선택 뷰
struct StarRatingView: View {
  // MARK: Properties
  @Binding var rating: Double
  let size: ComponentSizeType
  let isMyReview: Bool
  
  private let minimumRating: Double = 0.0
  private let maximumRating: Double = 5.0
  private let spacing: CGFloat
  private let starWidth: CGFloat
  
  init(rating: Binding<Double>, size: ComponentSizeType, isMyReview: Bool = false) {
    self._rating = rating
    self.size = size
    switch size {
    case .M:
      self.spacing = 8
    case .S:
      self.spacing = 1
    default:
      self.spacing = 1
    }
    self.starWidth = size.StarRatingSize
    self.isMyReview = isMyReview
  }
  
  // MARK: Body
  var body: some View {
    HStack(spacing: spacing) {
      // filled
      ForEach(0..<Int(rating), id: \.self) { number in
        HStack {
          if isMyReview {
            invertedFilledStarImage
          } else {
            normalFilledStarImage
          }
        }
        .onTapGesture {
          rating = ceil(Double(number))
        }
      }
      // filled half
      if rating != round(rating) {
        HStack {
          if isMyReview {
            invertedHalfStarImage
          } else {
            normalHalfStarImage
          }
        }
        .onTapGesture {
          rating = ceil(rating)
        }
      }
      // empty
      ForEach(0..<Int(maximumRating - rating), id: \.self) { number in
        HStack {
          if isMyReview {
            invertedEmptyStarImage
          } else {
            normalEmptyStarImage
          }
        }
        .onTapGesture {
          rating = ceil(Double(number) + rating) + 1
        }
      }
    } // HStack
    .gesture(
      DragGesture().onChanged(changeDragGesture(value:))
    )
    .disabled(size != .M ? true : false)
  }
  
  private var normalFilledStarImage: some View {
    Image("star-yellow")
      .resizable()
      .frame(width: starWidth, height: starWidth)
  }
  
  private var normalHalfStarImage: some View {
    HStack(spacing: 0) {
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
    .frame(width: starWidth)
  }
  
  private var normalEmptyStarImage: some View {
    Image("star-off")
      .resizable()
      .frame(width: starWidth, height: starWidth)
  }
  
  private var invertedFilledStarImage: some View {
    Image("star-on")
      .resizable()
      .renderingMode(.template)
      .foregroundColor(.odya.label.r_normal)
      .frame(width: starWidth, height: starWidth)
  }
  
  private var invertedHalfStarImage: some View {
    HStack(spacing: 0) {
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
    }
    .frame(width: starWidth)
  }
  
  private var invertedEmptyStarImage: some View {
    Image("star-off")
      .resizable()
      .renderingMode(.template)
      .foregroundColor(.odya.label.r_normal)
      .frame(width: starWidth, height: starWidth)
  }
  
  func changeDragGesture(value: DragGesture.Value) {
    let minimum = minimumRating
    let maximum = maximumRating
    let spacing: CGFloat = spacing
    let starWidth: CGFloat = starWidth
     
    let x = value.location.x

    let count = (x / CGFloat(starWidth + spacing)) + minimum
     
    switch count {
    case let x where x < minimum:
      self.rating = minimum
    case let x where x > maximum:
      self.rating = maximum
    default:
      self.rating = ceil(count * 2) / 2
    }
  }
}

// MARK: - Previews
struct StarRatingView_Previews: PreviewProvider {
  static var previews: some View {
    StarRatingView(rating: .constant(3.5), size: .M)
  }
}
