//
//  RecentSearchCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/15.
//

import SwiftUI

struct RecentSearchCell: View {
  // MARK: - Properties
  @EnvironmentObject var viewModel: LocationSearchViewModel
  let searchText: String

  // MARK: - Body
  var body: some View {
    HStack(spacing: 4) {
      // 최근검색어 버튼
      Button {
        // 검색어 대치
        viewModel.queryFragment = searchText
        viewModel.appendRecentSearch()
      } label: {
        Text(searchText)
          .detail1Style()
          .foregroundColor(.odya.label.assistive)
      }

      // 삭제 버튼
      Button {
        viewModel.removeRecentSearch(searchText: searchText)
      } label: {
        Image("x")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.odya.label.assistive)
          .frame(width: 10, height: 10)
      }
    } // HStack
    .padding(8)
  }
}

// MARK: - Previews
struct RecentSearchCell_Previews: PreviewProvider {
  static var previews: some View {
    RecentSearchCell(searchText: "")
  }
}
