//
//  DailyJournalComposeView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/16.
//

import SwiftUI
import Photos

struct DailyJournalComposeView: View {

  // MARK: Properties
    @EnvironmentObject var travelJournalEditVM: TravelJournalEditViewModel
    
    let index: Int
    @Binding var dailyJournal: DailyTravelJournal
    @Binding var isDatePickerVisible: Bool
    
    @State var isShowingImagePickerSheet = false
    
    @State private var isShowingDailyJournalDeleteAlert = false
    @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
    
    private var dayIndexString: String {
      let dayIndex = dailyJournal.getDayIndex(startDate: travelJournalEditVM.startDate)
      return dayIndex == 0 ? "Day " : "Day \(dayIndex)"
    }
    
  // MARK: Body

  var body: some View {
    VStack(spacing: 0) {
      headerBar
        DailyJournalContentEditView(index: index, dailyJournal: $dailyJournal, isShowingImagePickerSheet: $isShowingImagePickerSheet, isDatePickerVisible: $isDatePickerVisible)
            .environmentObject(travelJournalEditVM)
    }
    .padding(.horizontal, 20)
    .padding(.top, 16)
    .padding(.bottom, 24)
    .cornerRadius(Radius.medium)
    .background(Color.odya.elevation.elev2)
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $dailyJournal.images, accessStatus: imageAccessStatus)
    }

  }

  // MARK: Header bar
  private var headerBar: some View {
    HStack(spacing: 8) {
      Image("sparkle-m")
      Text(dayIndexString)
        .h4Style()
        .foregroundColor(.odya.brand.primary)

      Spacer()

      Button(action: {
        isShowingDailyJournalDeleteAlert = true
      }) {
        Text("삭제하기")
          .font(Font.custom("Noto Sans KR", size: 14))
          .underline()
          .foregroundColor(.odya.label.assistive)
      }.padding(.trailing, 8)
        .alert("해당 날짜의 여행일지를 삭제할까요?", isPresented: $isShowingDailyJournalDeleteAlert) {
          HStack {
              Button("취소", role: .cancel) {
              isShowingDailyJournalDeleteAlert = false
            }
              Button("삭제", role: .destructive) {
              isShowingDailyJournalDeleteAlert = false
              travelJournalEditVM.deleteDailyJournal(dailyJournal: dailyJournal)
            }
          }
        } message: {
          Text("삭제된 내용은 복구될 수 없습니다.")
        }

      // TODO: 꾹 눌러서 이동하는 기능 추가
      IconButton("menu-hamburger-l") {
        print("이동 버튼 클릭")
      }.colorMultiply(Color.odya.label.assistive)
    }
  }

  
}

struct DailyJournalComposeView_Previews: PreviewProvider {
  static var previews: some View {
      TravelJournalComposeView()
//      DailyJournalComposeView(
//        index: 1, dailyJournal: .constant(DailyTravelJournal()), isDatePickerVisible: .constant(false))
  }
}
