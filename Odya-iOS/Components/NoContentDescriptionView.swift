//
//  NoContentDescriptionView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/16.
//

import SwiftUI

/// 컨텐츠가 존재하지 않음을 표시하는 뷰
/// - Note: 로고가 있는 경우는 높이가 조금씩 달라서 생성하는 곳에서 지정해주세요. 로고가 없는 경우는 높이 124 고정입니다
struct NoContentDescriptionView: View {
  let title: String
  let withLogo: Bool
  
  init(title: String, withLogo: Bool) {
    self.title = title
    self.withLogo = withLogo
  }
  
  var body: some View {
    if withLogo {
      VStack(spacing: 8) {
        Image("logo-lightgray")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(width: 136, height: 43)
        Text(title)
          .detail1Style()
      }
      .foregroundColor(.odya.label.assistive)
      .frame(maxWidth: .infinity)
    } else {
      Text(title)
        .b1Style()
        .foregroundColor(.odya.elevation.elev6)
        .frame(height: 124)
    }
  }
}

struct NoContentDescriptionView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      NoContentDescriptionView(title: "설명을 입력하세요", withLogo: true)
      NoContentDescriptionView(title: "설명을 입력하세요", withLogo: false)
    }
  }
}
