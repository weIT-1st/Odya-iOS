//
//  ReviewComposeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import SwiftUI

/// 한줄리뷰 작성뷰
struct ReviewComposeView: View {
  // MARK: Properties
  @EnvironmentObject var viewModel: ReviewViewModel
  @Binding var isPresented: Bool
  @Binding var placeId: String
  /// 리뷰 아이디
  @State var reviewId: Int = -1
  /// 리뷰 내용 텍스트
  @State var reviewText: String = ""
  /// 별점
  @State var rating: Double = 0.0
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 18) {
      title
      
      VStack(spacing: 16) {
        // 별점
        StarRatingView(rating: $rating, size: .M)
        contentEditView
      }
      .padding(.horizontal, GridLayout.side)
      
      CTAButton(isActive: validate() ? .active : .inactive, buttonStyle: .solid, labelText: "등록하기", labelSize: .L) {
        if reviewId >= 0 {
          viewModel.updateReview(reviewId: reviewId, rating: rating, review: reviewText)
        } else {
          viewModel.createReview(placeId: placeId, rating: rating, review: reviewText)
        }
      }
      .disabled(!validate())
    }
    .padding(GridLayout.side)
    .padding(.top, 20)
    .background(Color.odya.background.normal)
    .disabled(viewModel.isProgressing)
    .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
      Button {
        isPresented.toggle()
      } label: {
        Text("닫기")
      }
    } message: {
      Text(viewModel.alertMessage)
    }
    .onChange(of: viewModel.isPosted) { _ in
      isPresented.toggle()
    }
  }
  
  private var title: some View {
    HStack {
      Text("리뷰 작성")
        .h4Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
    }
    .padding(.horizontal, GridLayout.side)
  }
  
  /// 리뷰 내용 작성 텍스트필드
  private var contentEditView: some View {
    VStack {
      TextField("", text: $reviewText, axis: .vertical)
        .b1Style()
        .foregroundColor(.odya.label.normal)
        .placeholder(when: reviewText.isEmpty) {
          Text("리뷰를 작성해주세요 ( 30자 이내 )")
            .b2Style()
            .foregroundColor(.odya.label.alternative)
        }
    }
    .padding(15)
    .frame(maxHeight: .infinity, alignment: .topLeading)
    .background(Color.odya.elevation.elev3)
    .cornerRadius(Radius.medium)
  }
  
  private func validate() -> Bool {
    if reviewText.count > 30 {
      DispatchQueue.main.async {
        self.reviewText.removeLast()
      }
    }
    
    if reviewText.isEmpty || rating == 0.0 {
      return false
    } else if reviewText.count > 30 {
      return false
    } else {
      return true
    }
  }
}

// MARK: - Previews
struct ReviewComposeView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewComposeView(isPresented: .constant(true), placeId: .constant(""))
  }
}
