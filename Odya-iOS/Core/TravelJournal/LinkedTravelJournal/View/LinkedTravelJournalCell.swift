//
//  LinkedTravelJournalCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import SwiftUI

struct LinkedTravelJournalCell: View {
  // MARK: Properties
  let content: TravelJournalData
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 0) {
      // title & lock icon
      HStack(alignment: .top) {
        Text(content.title)
          .b1Style()
        Spacer()
        Image("lock")
      }
      Spacer()
      // date
      HStack {
        Spacer()
        Text(content.startDateString)
          .detail2Style()
      }
    }
    .padding(16)
    .frame(height: 85)
  }
}
