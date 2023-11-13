//
//  TravelJournalDetailBottomSheet.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/26.
//

import SwiftUI

struct JournalDetailBottomSheet: View {

  // MARK: Properties

  @EnvironmentObject var bottomSheetVM: BottomSheetViewModel
  @EnvironmentObject var journalDetailVM: TravelJournalDetailViewModel

  let journalId: Int
  let title: String
  let startDate: Date
  let endDate: Date
  var contents: [DailyJournal] = []
  var mates: [TravelMate] = []

  @State private var showTravelMateList: Bool = false

  var startDateString: String {
    return startDate.dateToString(format: "yyyy.MM.dd")
  }
  var endDateString: String {
    return endDate.dateToString(format: "yyyy.MM.dd")
  }

  init(travelJournal: TravelJournalDetailData) {
      journalId = travelJournal.journalId
    title = travelJournal.title
    startDate = travelJournal.travelStartDate
    endDate = travelJournal.travelEndDate
    contents = travelJournal.dailyJournals
    mates = travelJournal.travelMates
  }

  // MARK: Body

  var body: some View {
    ZStack {
      OffsettableScrollView { point in
        if point.y != 0 {
          bottomSheetVM.isScrollAtTop = point.y > 0
        }
      } content: {
        journalInfo
          .padding(.horizontal, GridLayout.side)
          .padding(.top, 30)
          .padding(.bottom, 12)

        VStack(spacing: 24) {
          viewModeSelector

          ForEach(self.contents, id: \.id) { dailyJournal in
            let dayN: Int = Int(dailyJournal.travelDate.timeIntervalSince(self.startDate) / 86400) + 1
            HStack(alignment: .top, spacing: 16) {
              VStack(spacing: 12) {
                Text("Day\(dayN)")
                  .b1Style()
                  .foregroundColor(.odya.label.normal)
                  .frame(height: 12)
                  .padding(.bottom, 7)
                SparkleIcon()
                if dailyJournal != self.contents.last {
                  Rectangle()
                    .frame(width: 4)
                    .foregroundColor(Color.odya.elevation.elev6)
                }
              }.frame(width: 50)

                DailyJournalView(journalId: journalId, dailyJournal: dailyJournal)
            }
          }

        }
        .padding(.top, 25)
        .padding(.bottom, 200)
        .padding(.horizontal, GridLayout.side)
        .background(Color.odya.elevation.elev1)
        .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
      }.disabled(!bottomSheetVM.isSheetOn)

      // drag indicator
      VStack {
        Capsule()
          .fill(Color.odya.label.assistive)
          .frame(width: 80, height: 4)
          .padding(.vertical, 15)
        Spacer()
      }

    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    .background(Color.odya.background.dimmed_system)
    .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.medium))
    .ignoresSafeArea(edges: [.bottom])
    .sheet(isPresented: $showTravelMateList) {
      TravelMatesView(mates: mates)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }

  // MARK: Journal Info
  private var journalInfo: some View {
    VStack(alignment: .leading) {
      // 여행 제목
      Text(title)
        .h5Style()
        .foregroundColor(.odya.label.normal)
        .lineLimit(bottomSheetVM.isSheetOn ? 1 : nil)
        .padding(.vertical)

      HStack {
        Button(action: {
            showTravelMateList = true
        }) {
          HStack(spacing: 0) {
            let displayedMates = mates.filter({ $0.isRegistered }).prefix(2)
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

        Spacer()

        // 여행 기간
        Text("\(startDateString) ~ \(endDateString)")
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
      }
    }
  }

  // MARK: View Mode Selector
  private var viewModeSelector: some View {
    HStack {
      Button(action: {
          journalDetailVM.isAllExpanded.toggle()
      }) {
          Text(!journalDetailVM.isAllExpanded ? "전부 펼쳐보기" : "전부 접기")
          .b1Style()
          .foregroundColor(.odya.label.alternative)
      }
      Spacer()
      IconButton("feed") {
          journalDetailVM.isFeedType = true
      }
      .colorMultiply(journalDetailVM.isFeedType ? Color.odya.brand.primary : Color.odya.label.normal)
      IconButton("grid") {
          journalDetailVM.isFeedType = false
      }
      .colorMultiply(!journalDetailVM.isFeedType ? Color.odya.brand.primary : Color.odya.label.normal)

    }
  }
}

struct JournalDetailBottomSheet_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalDetailView(journalId: 1)
    //        JournalDetailBottomSheet(isSheetOn: .constant(.journalDetailOn), travelJournal: TravelJournalData.getDummy())
  }
}
