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
  @ObservedObject var journalEditVM: DailyJournalEditViewModel

  @State private var isDatePickerVisible: Bool = false
  @State private var isShowingImagePickerSheet = false
  @State private var isDismissAlertVisible: Bool = false

  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized

  // daily journal data
  @State private var date: Date
  @State private var content: String
  @State private var placeId: String?
  @State private var latitudes: [Double] = []
  @State private var longitudes: [Double] = []
  @State private var fetchedImages: [DailyJournalImage] = []
  @State private var selectedImages: [ImageData] = []

  init(journal: TravelJournalDetailData, editedJournal: DailyJournal) {
    self.journalEditVM = DailyJournalEditViewModel(journal: journal, dailyJournal: editedJournal)
    self._date = State(initialValue: editedJournal.travelDate)
    self._content = State(initialValue: editedJournal.content)
    self._placeId = State(initialValue: editedJournal.placeId)
    self._latitudes = State(initialValue: editedJournal.latitudes)
    self._longitudes = State(initialValue: editedJournal.longitudes)
    self._fetchedImages = State(initialValue: editedJournal.images)
  }

  // MARK: Body

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        headerBar
        ContentEditView(
          isDatePickerVisible: $isDatePickerVisible,
          isShowingImagePickerSheet: $isShowingImagePickerSheet,
          date: $date,
          content: $content,
          placeId: $placeId,
          latitudes: $latitudes,
          longitudes: $longitudes,
          fetchedImages: $fetchedImages,
          selectedImages: $selectedImages
        )
        .environmentObject(journalEditVM)
        .padding(.horizontal, GridLayout.side)
        Spacer()
      }.padding(.bottom, 24)

      if isDatePickerVisible {
        DailyJournalDateEditor(
          editedDate: $date, travelStartDate: journalEditVM.startDate,
          travelEndDate: journalEditVM.endDate, isDatePickerVisible: $isDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }
    }
    .background(Color.odya.background.normal)
    .onDisappear {
      journalDetailVM.getJournalDetail(journalId: journalEditVM.journalId)
    }
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $selectedImages, accessStatus: imageAccessStatus)
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
      let dayN: Int = Int(date.timeIntervalSince(journalEditVM.startDate) / 86400) + 1
      CustomNavigationBar(title: "Day \(dayN)")
      HStack {
        IconButton("direction-left") {
          isDismissAlertVisible = true
        }.padding(.leading, 8)
        Spacer()
        Button(action: {
          journalDetailVM.editedDailyJournal = nil
          Task {
            await journalEditVM.updateDailyJournal(
              date: date, content: content, placeId: placeId, latitudes: latitudes,
              longitudes: longitudes, fetchedImages: fetchedImages, selectedImages: selectedImages)
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
