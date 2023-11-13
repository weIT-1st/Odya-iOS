//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import Photos
import SwiftUI

/// 여행일지 데일리 일정 수정 뷰
struct DailyJournalEditView: View {

  // MARK: Properties
  @EnvironmentObject var journalDetailVM: TravelJournalDetailViewModel
  @ObservedObject var journalEditVM: JournalEditViewModel

  @State private var isDatePickerVisible: Bool = false
  @State private var isShowingImagePickerSheet = false
  @State private var isDismissAlertVisible: Bool = false

  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized

  init(journal: TravelJournalDetailData, editedJournal: DailyJournal) {
    self.journalEditVM = JournalEditViewModel(journal: journal, dailyJournal: editedJournal)
  }

  // MARK: Body

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        headerBar
        ContentEditView(
          isDatePickerVisible: $isDatePickerVisible,
          isShowingImagePickerSheet: $isShowingImagePickerSheet
        )
        .environmentObject(journalEditVM)
        .padding(.horizontal, GridLayout.side)
        Spacer()
      }.padding(.bottom, 24)

      if isDatePickerVisible {
        DailyJournalDateEditor(
          editedDate: $journalEditVM.date, travelStartDate: journalEditVM.startDate,
          travelEndDate: journalEditVM.endDate, isDatePickerVisible: $isDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }
    }
    .background(Color.odya.background.normal)
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $journalEditVM.selectedImages, accessStatus: imageAccessStatus)
    }
    .confirmationDialog("", isPresented: $isDismissAlertVisible) {
      Button("작성취소", role: .destructive) {
        journalDetailVM.editedDailyJournal = nil
      }
      Button("취소", role: .cancel) {}
    } message: {
      Text("작성 중인 글을 취소하시겠습니까?\n작성 취소 선택시, 작성된 글은 저장되지 않습니다.")
    }
  }

  private var headerBar: some View {
    ZStack {
      let dayN: Int = Int(journalEditVM.date.timeIntervalSince(journalEditVM.startDate) / 86400) + 1
      CustomNavigationBar(title: "Day \(dayN)")
      HStack {
        IconButton("direction-left") {
          isDismissAlertVisible = true
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
