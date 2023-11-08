//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import SwiftUI

struct DailyJournalEditView: View {

  // MARK: Properties
  //    @EnvironmentObject var travelJournalEditVM: TravelJournalEditViewModel
  @StateObject var travelJournalEditVM = TravelJournalEditViewModel()

  let dayN: Int
  @Binding var dailyJournal: DailyJournal
  @State var isDatePickerVisible: Bool = false
  @State private var isShowingImagePickerSheet = false

  // MARK: Body

  var body: some View {
    VStack(spacing: 0) {
      headerBar
      ContentEditView(
        dailyJournal: dailyJournal,
        isShowingImagePickerSheet: $isShowingImagePickerSheet,
        isDatePickerVisible: $isDatePickerVisible
      )
      .environmentObject(travelJournalEditVM)
      .padding(.horizontal, GridLayout.side)
    }
    .padding(.bottom, 24)
    .background(Color.odya.background.normal)

  }

  private var headerBar: some View {
    ZStack {
      CustomNavigationBar(title: "Day \(dayN)")
      HStack {
        Spacer()
        Button(action: {}) {
          Text("수정 완료")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
            .padding(.trailing, 12)
        }
      }
    }
  }
}

//struct DailyJournalEditView_Previews: PreviewProvider {
//  static var previews: some View {
//    DailyJournalEditView(
//        dayN: 1, dailyJournal: .constant(DailyJournal())
////    )
//  }
//}
