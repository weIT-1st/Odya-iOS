//
//  MyReviewsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/26.
//

import SwiftUI

struct MyReviewListView: View {
  @EnvironmentObject var VM: MyReviewsViewModel
  
  var body: some View {
    LazyVStack(spacing: 12) {
      ForEach(VM.reviews, id: \.id) { review in
        MyReviewCardView(placeName: review.placeId,
                         rating: review.starRating,
                         review: review.review,
                         date: review.createdAt.toDate())
        .onAppear {
          if let last = VM.lastId,
             last == review.reviewId
          {
            VM.fetchMoreReviewSubject.send()
          }
        } // onAppear
        
      } // ForEach
    } // LazyVStack
  } // body
}
