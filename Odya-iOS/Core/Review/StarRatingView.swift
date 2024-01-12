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
  
  private let minimumRating: Double = 0.0
  private let maximumRating: Double = 5.0
  private let spacing: CGFloat = 8
  private let starWidth: CGFloat = 40
  
  // MARK: Body
  var body: some View {
    HStack(spacing: spacing) {
      // filled
      ForEach(0..<Int(rating), id: \.self) { number in
        filledStarImage
          .onTapGesture {
            rating = ceil(Double(number))
          }
      }
      // filled half
      if rating != round(rating) {
        halfStarImage
          .onTapGesture {
            rating = ceil(rating)
          }
      }
      // empty
      ForEach(0..<Int(maximumRating - rating), id: \.self) { number in
        emptyStarImage
          .onTapGesture {
            rating = ceil(Double(number) + rating) + 1
          }
      }
    } // HStack
    .gesture(
      DragGesture().onChanged(changeDragGesture(value:))
    )
  }
  
  private var filledStarImage: some View {
    Image("star-yellow")
      .resizable()
      .frame(width: starWidth, height: starWidth)
  }
  
  private var halfStarImage: some View {
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
  
  private var emptyStarImage: some View {
    Image("star-off")
      .resizable()
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
    StarRatingView(rating: .constant(3.5))
  }
}
