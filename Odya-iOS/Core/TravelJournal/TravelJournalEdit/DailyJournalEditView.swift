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
    
    let index: Int
    @Binding var dailyJournal: DailyTravelJournal
    @Binding var isDatePickerVisible: Bool
    @State private var isShowingImagePickerSheet = false

  // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            DailyJournalContentEditView(index: index, dailyJournal: $dailyJournal, isShowingImagePickerSheet: $isShowingImagePickerSheet, isDatePickerVisible: $isDatePickerVisible)
                .environmentObject(travelJournalEditVM)
                .padding(.horizontal, GridLayout.side)
        }
        .padding(.bottom, 24)
        .background(Color.odya.background.normal)
        
    }
    
    private var headerBar: some View {
        ZStack {
            CustomNavigationBar(title: "Day 1")
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

struct DailyJournalEditView_Previews: PreviewProvider {
  static var previews: some View {
      DailyJournalEditView(index: 1, dailyJournal: .constant(DailyTravelJournal()), isDatePickerVisible: .constant(false))
  }
}
