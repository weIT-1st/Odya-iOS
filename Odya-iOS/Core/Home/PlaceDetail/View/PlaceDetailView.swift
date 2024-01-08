//
//  PlaceDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import SwiftUI

/// 장소 상세보기 뷰
struct PlaceDetailView: View {
  // MARK: Properties
  @EnvironmentObject var placeInfo: PlaceInfo
  @Binding var isPresented: Bool
  
  @State private var showReviewComposeView: Bool = false
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 24) {
      navigationBar
      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          bottomSheetIndicator
          
          VStack(spacing: 16) {
            Text("해운대 해수욕장의 방문 경험은 어떠셨나요?")
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
        .background(Color.odya.background.normal)
      }
      .clipShape(RoundedEdgeShape(edgeType: .top))
    }
    .frame(maxWidth: .infinity)
    .sheet(isPresented: $showReviewComposeView) {
      ReviewComposeView(placeId: $placeInfo.placeId)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        isPresented = false
      } label: {
        Image("direction-left")
          .frame(width: 36, height: 36)
      }
      Spacer()
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
  }
  
  private var bottomSheetIndicator: some View {
    VStack {
      Capsule()
        .foregroundColor(.odya.label.assistive)
        .frame(width: 80, height: 4)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 34)
  }
}

// MARK: - Previews
struct PlaceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailView(isPresented: .constant(true))
  }
}
