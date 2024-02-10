//
//  MainJournalCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct MainJournalCardView: View {
  @StateObject private var viewModel = MainJournalCardViewModel()
  
  let totalWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)
  let journalId: Int
  
  init(journalId: Int) {
    self.journalId = journalId
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
    }
    .onAppear {
      viewModel.fetchTravelJournalDetail(journalId: journalId)
    }
    .onChange(of: journalId) { newValue in
      viewModel.fetchTravelJournalDetail(journalId: newValue)
    }
  }

  // MARK: Card

  let shadowBoxWidth: CGFloat = 16
  var cardWidth: CGFloat { totalWidth - (shadowBoxWidth * 2) }
  let cardHeight: CGFloat = 280

  private var cardView: some View {
    JournalCardMapView(size: .medium, dailyJournals: $viewModel.myDailyJournals)
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
    Text(viewModel.title)
      .h6Style()
      .foregroundColor(.odya.label.normal)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var journalDate: some View {
    Text(viewModel.dateString)
      .detail2Style()
      .foregroundColor(.odya.label.assistive)
  }

  private var travelMates: some View {
    HStack(spacing: 0) {
      HStack(spacing: -8) {
        ForEach(viewModel.mates.prefix(2), id: \.id) { mate in
          if let url = mate.profileUrl {
            ProfileImageView(profileUrl: url, size: .S)
          }
        }
      }

      if viewModel.mates.count > 2 {
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
      Text(viewModel.content)
        .detail2Style()
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .foregroundColor(.odya.label.assistive)
    .padding(16)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.large)
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
