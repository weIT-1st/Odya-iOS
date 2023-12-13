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
  /// 셀에 표시할 여행일지 목록 하나의 데이터
  let content: TravelJournalData
  /// '비공개' 상수
  let privateVisibility = "PRIVATE"
  /// 선택된 여행일지 아이디
  @Binding var selectedId: Int?
  
  // MARK: Body
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        // title & lock icon
        HStack(alignment: .top) {
          Text(content.title)
            .b1Style()
            .foregroundColor(content.visibility == privateVisibility ? .odya.label.assistive : .odya.label.alternative)
          Spacer()
          if content.visibility == privateVisibility {
            Image("lock")
          }
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
      if content.visibility != privateVisibility && selectedId == content.journalId {
        RoundedRectangle(cornerRadius: Radius.medium)
          .inset(by: 1)
          .stroke(Color.odya.brand.primary, lineWidth: 2)
      }
    }
    .background(content.visibility == privateVisibility ? Color.odya.background.dimmed_dark : .black.opacity(0.2))
    .cornerRadius(Radius.medium)
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
