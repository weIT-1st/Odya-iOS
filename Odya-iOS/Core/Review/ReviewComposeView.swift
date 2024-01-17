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
  @StateObject private var viewModel = ReviewComposeViewModel()
  @Binding var isPresented: Bool
  @Binding var placeId: String
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 18) {
      title
      
      VStack(spacing: 16) {
        // 별점
        StarRatingView(rating: $viewModel.rating, size: .M)
        contentEditView
      }
      .padding(.horizontal, GridLayout.side)
      
      CTAButton(isActive: viewModel.validate() ? .active : .inactive, buttonStyle: .solid, labelText: "등록하기", labelSize: .L) {
        // action: 한줄리뷰 생성
        viewModel.createReview(placeId: placeId)
      }
      .disabled(!viewModel.validate())
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
    .onChange(of: viewModel.isPosted) { newValue in
      if newValue {
        isPresented.toggle()
      }
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
      TextField("", text: $viewModel.reviewText, axis: .vertical)
        .b1Style()
        .foregroundColor(.odya.label.normal)
        .placeholder(when: viewModel.reviewText.isEmpty) {
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
}

// MARK: - Previews
struct ReviewComposeView_Previews: PreviewProvider {
  static var previews: some View {
    ReviewComposeView(isPresented: .constant(true), placeId: .constant(""))
  }
}
