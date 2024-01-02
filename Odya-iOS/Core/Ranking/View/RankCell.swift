//
//  RankCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/02.
//

import SwiftUI

/// 오댜 핫플 랭킹 셀
struct RankCell: View {
  // MARK: Properties
  let rank: Int
  let title: String
  
  init(index rank: Int, title: String) {
    self.rank = rank + 1
    self.title = title
  }
  
  // MARK: Body
  var body: some View {
    HStack(spacing: 8) {
      Text("\(rank)위")
        .detail1Style()
        .frame(width: 36, height: 36)
        .foregroundColor(1...3 ~= rank ? .odya.brand.primary : .odya.system.inactive)
      if 1...3 ~= rank {
        Text(title)
          .detail1Style()
          .foregroundColor(.odya.label.normal)
      } else {
        Text(title)
          .detail2Style()
          .foregroundColor(.odya.label.normal)
      }
    }
  }
}

// MARK: - Previews
struct RankCell_Previews: PreviewProvider {
  static var previews: some View {
    RankCell(index: 1, title: "해운대 해수욕장")
  }
}
