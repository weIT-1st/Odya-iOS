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
  
  // MARK: Body
  var body: some View {
    VStack {
      CTAButton(isActive: .active, buttonStyle: .ghost, labelText: "리뷰 작성", labelSize: .L) {
        // action: 한줄리뷰 작성 바텀시트 열기
      }
    }
  }
}

// MARK: - Previews
struct PlaceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailView()
  }
}
