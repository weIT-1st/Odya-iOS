//
//  MainJournalCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct MainJournalCardView: View {
  let totalWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)
  
  let journalId: Int
  let mainJournalId: Int
  let title: String
  let dateString: String
  let mates: [travelMateSimple]
  let content: String
  
  init(mainJournal: MainJournalData) {
    self.journalId = mainJournal.journalId
    self.mainJournalId = mainJournal.repJournalId
    self.title = mainJournal.title
    self.dateString = "\(mainJournal.travelStartDate.dateToString(format: "MM.dd")) ~ \(mainJournal.travelEndDate.dateToString(format: "MM.dd"))"
    self.mates = mainJournal.travelMates
    self.content = mainJournal.content
  }
  
  var body: some View {
    VStack(spacing: 20) {
      ZStack(alignment: .leading) {
        shadowBox
          .offset(x: 32)
        shadowBox
          .offset(x: 16)
        HStack {
          cardView
          Spacer()
        }
      }.frame(width: totalWidth)
      
      journalContent
        .frame(width: totalWidth, height: contentHeight)
    }
  }


  // MARK: Card
  
  let shadowBoxWidth: CGFloat = 16
  var cardWidth: CGFloat { totalWidth - (shadowBoxWidth * 2) }
  let cardHeight: CGFloat = 280
  
  private var cardView: some View {
    Rectangle()
      .frame(width: cardWidth, height: cardHeight)
      .foregroundColor(.odya.brand.primary)
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
          journalTitle
            .offset(x: -5)
          journalDate
          Spacer()
          travelMates
        }
        .padding(.horizontal, GridLayout.side)
        .padding(.top, 26)
        .padding(.bottom, 16)
        .frame(width: cardWidth)
      }
  }
  
  private var journalTitle: some View {
    Text(title)
      .h6Style()
      .foregroundColor(.odya.label.normal)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var journalDate: some View {
    Text(dateString)
      .detail2Style()
      .foregroundColor(.odya.label.assistive)
  }

  private var travelMates: some View {
    HStack(spacing: 0) {
      let displayedMates = mates.prefix(2)
      ForEach(Array(displayedMates.enumerated()), id: \.element.id) { index, mate in
        if let url = mate.profileUrl {
          ProfileImageView(profileUrl: url, size: .S)
            .offset(x: index == 1 ? -8 : 0)
        }
      }

      if mates.count > 2 {
        Text("더보기")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          .offset(x: -8)
      }
    }
  }

  // MARK: Content
  
  let contentHeight: CGFloat = 100
  
  private var journalContent: some View {
    ZStack {
      RoundedRectangle(cornerRadius: Radius.large)
        .foregroundColor(.odya.elevation.elev4)
        .frame(width: totalWidth, height: contentHeight, alignment: .top)
      HStack(alignment: .top, spacing: 10) {
        Image("pen-s")
          .renderingMode(.template)
        Text(content)
          .detail2Style()
          .frame(width: totalWidth - 50, height: contentHeight - 30)
          .multilineTextAlignment(.leading)
      }.foregroundColor(.odya.label.assistive)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 16)
    
  }
  
  // MARK: Shadow
  private var shadowBox: some View {
    RoundedRectangle(cornerRadius: Radius.large)
      .foregroundColor(Color.odya.whiteopacity.baseWhiteAlpha20)
      .frame(width: cardWidth, height: cardHeight)
  }
}

//struct MainJournalCardView_Previews: PreviewProvider {
//  static var previews: some View {
//    MainJournalCardView()
//  }
//}
