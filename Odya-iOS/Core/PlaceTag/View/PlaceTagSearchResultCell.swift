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
  @Binding var selectedPlaceId: String?
  let title: String
  let address: String
  let placeId: String
  
  var isSelected: Bool {
    if selectedPlaceId == placeId {
      return true
    } else {
      return false
    }
  }
  
  // MARK: Init
  init(selectedPlaceId: Binding<String?>, title: String, address: String, placeId: String) {
    self._selectedPlaceId = selectedPlaceId
    self.title = title
    self.address = address
    self.placeId = placeId
  }
  
  // MARK: Body
  var body: some View {
    HStack {
      VStack(spacing: 8) {
        HStack {
          Text(title)
            .b1Style()
            .foregroundColor(isSelected ? Color.odya.background.normal : Color.odya.label.normal)
          Spacer()
        }
        HStack {
          Text(address)
            .detail2Style()
            .foregroundColor(isSelected ? Color.odya.background.dimmed_dark : Color.odya.label.alternative)
          Spacer()
        }
      }
      
      Spacer()
      
      if isSelected {
        Image("system-check-circle-subtract")
          .padding(10)
      } else {
        Image("system-check-circle")
          .renderingMode(.template)
          .foregroundColor(isSelected ? Color.odya.background.normal : Color.odya.system.inactive)
          .padding(10)
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 8)
    .background(isSelected ? Color.odya.brand.primary : Color.odya.background.normal)
    .cornerRadius(Radius.large)
  }
}
