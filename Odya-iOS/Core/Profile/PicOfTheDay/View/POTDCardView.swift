//
//  POTDCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

/// 프로필 뷰에서 보여지는 인생샷
/// 인생샷 이미지와 태그된 장소가 보여짐
struct POTDCardView: View {
  let imageUrl: String
  let place: String?
  
  var body: some View {
    VStack(spacing: 20) {
      // 인생샷 이미지
      AsyncImageView(url: imageUrl,
                     width: 223, height: 223,
                     cornerRadius: Radius.medium)
      
      // 태그된 장소
      // 태그된 장소가 없을 경우엔 보여지지 않음, 카드뷰의 총 height는 변하지 않음
      HStack(spacing: 8) {
        Image("location-s")
          .renderingMode(.template)
        Text(place ?? "")
          .b2Style()
        Spacer()
      }
      .foregroundColor(place != nil ? .odya.label.assistive : .clear)
      .frame(width: 223)
    }
  }
}

struct POTDCardView_Previews: PreviewProvider {
  static var previews: some View {
    POTDCardView(imageUrl: "", place: "해운대해수욕장")
  }
}

