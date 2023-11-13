//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import SwiftUI
import Photos

struct DailyJournalEditView: View {

  // MARK: Properties
  @EnvironmentObject var journalDetailVM: TravelJournalDetailViewModel
    @ObservedObject var journalEditVM: JournalEditViewModel
    
  @State var isDatePickerVisible: Bool = false
  @State private var isShowingImagePickerSheet = false
    @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
    
    init(journal: TravelJournalDetailData, editedJournal: DailyJournal) {
        self.journalEditVM = JournalEditViewModel(journal: journal, dailyJournal: editedJournal)
    }

  // MARK: Body

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerBar
                ContentEditView(isDatePickerVisible: $isDatePickerVisible, isShowingImagePickerSheet: $isShowingImagePickerSheet)
                    .environmentObject(journalEditVM)
                    .padding(.horizontal, GridLayout.side)
                Spacer()
            }.padding(.bottom, 24)
            
            if isDatePickerVisible {
                DailyJournalDateEditor(editedDate: $journalEditVM.date, travelStartDate: journalEditVM.startDate, travelEndDate: journalEditVM.endDate, isDatePickerVisible: $isDatePickerVisible)
                    .padding(GridLayout.side)
                    .frame(maxHeight: .infinity)
                    .background(Color.odya.blackopacity.baseBlackAlpha80)
            }
        }
        .background(Color.odya.background.normal)
        .sheet(isPresented: $isShowingImagePickerSheet) {
            PhotoPickerView(imageList: $journalEditVM.selectedImages, accessStatus: imageAccessStatus)
        }
    }

  private var headerBar: some View {
    ZStack {
        let dayN: Int = Int(journalEditVM.date.timeIntervalSince(journalEditVM.startDate) / 86400) + 1
      CustomNavigationBar(title: "Day \(dayN)")
      HStack {
          IconButton("direction-left") {
              journalDetailVM.editedDailyJournal = nil
          }.padding(.leading, 8)
        Spacer()
        Button(action: {
            journalDetailVM.editedDailyJournal = nil
            Task {
                await journalEditVM.updateDailyJournal()
            }
        }) {
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
