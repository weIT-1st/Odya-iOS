//
//  PlaceTagSearchResultCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/17.
//

import SwiftUI

/// 검색 결과인 장소이름, 주소를 표시하는 셀
struct PlaceTagSearchResultCell: View {
  // MARK: Properties
  let title: String
  let address: String
  
  // MARK: Init
  init(title: String, address: String) {
    self.title = title
    self.address = address
  }
  
  // MARK: Body
  var body: some View {
    HStack {
      VStack(spacing: 8) {
        HStack {
          Text(title)
            .b1Style()
            .foregroundColor(Color.odya.label.normal)
          Spacer()
        }
        HStack {
          Text(address)
            .detail2Style()
            .foregroundColor(Color.odya.label.alternative)
          Spacer()
        }
      }
      
      Spacer()
      
      Button {
        // action: 장소 선택
      } label: {
        Image("system-check-circle")
          .renderingMode(.template)
          .foregroundColor(Color.odya.system.inactive)
          .padding(10)
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 8)
  }
}
