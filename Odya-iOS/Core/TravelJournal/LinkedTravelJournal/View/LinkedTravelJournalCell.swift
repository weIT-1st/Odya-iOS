//
//  LinkedTravelJournalCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import SwiftUI

/// 여행일지 연동화면의 나의 여행일지 셀
struct LinkedTravelJournalCell: View {
  // MARK: Properties
  let content: TravelJournalData
  @Binding var selectedId: Int?
  
  // MARK: Body
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        // title & lock icon
        HStack(alignment: .top) {
          Text(content.title)
            .b1Style()
            .foregroundColor(.odya.label.alternative)
//            .foregroundColor(.odya.label.assistive)
          Spacer()
          // TODO: private journal 인 경우
          Image("lock")
        }
        Spacer()
        // date
        HStack {
          Spacer()
          Text(content.startDateString)
            .detail2Style()
            .foregroundColor(.odya.label.assistive)
        }
      }
      .padding(16)
      if selectedId == content.journalId {
        RoundedRectangle(cornerRadius: Radius.medium)
          .inset(by: 1)
          .stroke(Color.odya.brand.primary, lineWidth: 2)
      }
    }
    .background(.black.opacity(0.2))
    .background(
      AsyncImage(url: URL(string: content.imageUrl)!, content: { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .clipped()
          .frame(height: 85)
          .cornerRadius(Radius.medium)
      }, placeholder: {
        ProgressView()
      })
    )
    .frame(height: 85)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, GridLayout.side)
  }
}
