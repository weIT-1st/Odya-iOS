//
//  LocationSearchResultCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

/**
 자동완성 검색 결과 표시하는 셀
 */
struct LocationSearchResultCell: View {
    // MARK: - Properties
    let title: String
    let subtitle: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // title
            Text(title)
                .font(.body)
            // subtitle
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Divider()
        }
        .padding(.leading, 8)
    }
}

// MARK: - Previews
struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(title: "", subtitle: "")
    }
}
