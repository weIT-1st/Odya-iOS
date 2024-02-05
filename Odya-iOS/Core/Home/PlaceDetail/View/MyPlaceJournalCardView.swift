//
//  MyPlaceJournalCardView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/25.
//

import SwiftUI
import CoreLocation

/// 장소 상세보기 - 나의 여행일지 카드 뷰
struct MyPlaceJournalCardView: View {
  // MARK: Properties
  let totalWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)
  let shadowBoxWidth: CGFloat = 12.87
  var cardWidth: CGFloat { totalWidth - shadowBoxWidth }
  let cardHeight: CGFloat = 280
  
  let placeId: String
  let myJournal: TravelJournalData
  @Binding var dailyJournals: [DailyJournal]
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 12) {
      ZStack(alignment: .leading) {
        shadowBox
          .offset(x: shadowBoxWidth, y: 1)
        HStack {
          cardView
          Spacer()
        }
      }
      .frame(width: totalWidth)
      
      journalContent
    }
  }
  
  // MARK: Card
  private var cardView: some View {
    JournalCardMapView(placeId: placeId, size: .medium, dailyJournals: $dailyJournals)
      .frame(width: cardWidth, height: cardHeight)
      .cornerRadius(Radius.large)
      .overlay {
        LinearGradient(
          stops: [
            Gradient.Stop(color: .black.opacity(0.5), location: 0.09),
            Gradient.Stop(color: .black.opacity(0), location: 1.00),
          ],
          startPoint: UnitPoint(x: 0.5, y: 0),
          endPoint: UnitPoint(x: 0.5, y: 1)
        ).cornerRadius(Radius.large)
      }
      .overlay {
        VStack(alignment: .leading, spacing: 0) {
          VStack(alignment: .leading, spacing: 14) {
            journalTitle
            journalDate
          }
          Spacer()
          travelMates
        }
        .padding(.leading, 23)
        .padding(.trailing, 21)
        .padding(.top, 25)
        .padding(.bottom, 13)
        .frame(width: cardWidth)
      }
  }
  
  private var journalTitle: some View {
    Text(myJournal.title)
      .h6Style()
      .foregroundColor(.odya.label.normal)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var journalDate: some View {
    HStack {
      let startDateString = myJournal.travelStartDate.dateToString(format: "yyyy .MM.dd")
      let endDateString = myJournal.travelEndDate.dateToString(format: "MM.dd")
      Text(startDateString + " ~ " + endDateString)
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }

  private var travelMates: some View {
    HStack(spacing: 0) {
      Spacer()
      HStack(spacing: -8) {
        ForEach(myJournal.travelMates.prefix(2), id: \.id) { mate in
          if let url = mate.profileUrl {
            ProfileImageView(profileUrl: url, size: .S)
          }
        }
      }
      if myJournal.travelMates.count > 2 {
        Text("더보기")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
      }
    }
  }
  
  // MARK: Content
  private var journalContent: some View {
    HStack(alignment: .top, spacing: 12) {
      Image("pen-s")
        .renderingMode(.template)
      Text(myJournal.content)
        .detail2Style()
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .foregroundColor(.odya.label.assistive)
    .padding(.vertical, 16)
    .padding(.horizontal, 10)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.large)
  }
  
  // MARK: Shadow
  private var shadowBox: some View {
    AsyncImage(url: URL(string: myJournal.imageUrl)!) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(Radius.large)
        .clipped()
    } placeholder: {
      RoundedRectangle(cornerRadius: Radius.large)
        .foregroundColor(Color.odya.label.inactive)
        .frame(width: cardWidth, height: cardHeight)
    }
  }
}
