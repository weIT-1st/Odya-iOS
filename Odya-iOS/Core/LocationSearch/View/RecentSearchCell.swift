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
        HStack {
            // 최근검색어 버튼
            Button {
                // 검색어 대치
                viewModel.queryFragment = searchText
                viewModel.appendRecentSearch()
            } label: {
                Text(searchText)
                    .font(.system(size: 12))
            }

            // 삭제 버튼
            Button {
                viewModel.removeRecentSearch(searchText: searchText)
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding(8)
        .background(
            Capsule()
                .stroke(.black, style: StrokeStyle(lineWidth: 1))
        )
    }
}

// MARK: - Previews
struct RecentSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        RecentSearchCell(searchText: "")
    }
}
