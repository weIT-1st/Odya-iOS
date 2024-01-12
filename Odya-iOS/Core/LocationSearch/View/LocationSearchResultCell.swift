//
//  LocationSearchResultCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

/// 자동완성 검색 결과 표시하는 셀
struct LocationSearchResultCell: View {
  // MARK: - Properties
  let title: String
  let subtitle: String

  // MARK: - Body
  var body: some View {
    HStack(spacing: 17) {
      Image("search")
        .renderingMode(.template)
        .foregroundColor(.odya.label.assistive)
        .frame(width: 38, height: 38)
        .background(
          Circle()
            .foregroundColor(.odya.elevation.elev6)
        )
      VStack(alignment: .leading, spacing: 8) {
        // title
        Text(title)
          .detail1Style()
          .foregroundColor(.odya.label.normal)
        // subtitle
        Text(subtitle)
          .detail2Style()
          .foregroundColor(.odya.label.alternative)
      }
      Spacer()
    }
  }
}

// MARK: - Previews
struct LocationSearchResultCell_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchResultCell(title: "서울대공원", subtitle: "경기 과천시 대공원광장로 102")
  }
}
