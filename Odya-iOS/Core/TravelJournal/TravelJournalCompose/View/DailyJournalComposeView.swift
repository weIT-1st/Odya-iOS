//
//  DailyJournalComposeView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/16.
//

import Photos
import SwiftUI

private struct DailyJournalHeaderBar: View {
  @EnvironmentObject var journalComposeVM: JournalComposeViewModel
  
  let dailyJournal: DailyTravelJournal
  let dayIndexString: String
  
  @State private var isShowingDeletionAlert: Bool = false
  @State private var isShowingNotEnoughAlert: Bool = false
  
  var body: some View {
    HStack(spacing: 8) {
      Image("sparkle-m")
      Text(dayIndexString)
        .h4Style()
        .foregroundColor(.odya.brand.primary)
      
      Spacer()
      
      Button(action: {
        isShowingDeletionAlert = true
      }) {
        Text("삭제하기")
          .font(Font.custom("Noto Sans KR", size: 14))
          .underline()
          .foregroundColor(.odya.label.assistive)
      }.padding(.trailing, 8)
        .alert("해당 날짜의 여행일지를 삭제할까요?", isPresented: $isShowingDeletionAlert) {
          HStack {
            Button("취소", role: .cancel) {
              isShowingDeletionAlert = false
            }
            Button("삭제", role: .destructive) {
              isShowingDeletionAlert = false
              if journalComposeVM.dailyJournalList.count <= 1 {
                isShowingNotEnoughAlert = true
              } else {
                print("delete daily journal \(dailyJournal)")
                // original -> delete api
                journalComposeVM.deleteDailyJournalWithApi(dailyJournal: dailyJournal)
              }
            }
          }
        } message: {
          Text("삭제된 내용은 복구될 수 없습니다.")
        }
        .alert("최소 1개의 여행일정이 필요합니다.", isPresented: $isShowingNotEnoughAlert) {}
      
      // TODO: 꾹 눌러서 이동하는 기능 추가
      IconButton("menu-hamburger-l") {
        print("이동 버튼 클릭")
      }.colorMultiply(Color.odya.label.assistive)
    }
  }
}

struct DailyJournalComposeView: View {

  // MARK: Properties
  @EnvironmentObject var journalComposeVM: JournalComposeViewModel

  let index: Int
  @Binding var dailyJournal: DailyTravelJournal
  @Binding var isDatePickerVisible: Bool

  @State var isShowingImagePickerSheet = false

  @State private var isShowingDailyJournalDeleteAlert = false
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized

  private var dayIndexString: String {
    let dayIndex = dailyJournal.getDayIndex(startDate: journalComposeVM.startDate)
    return dayIndex == 0 ? "Day " : "Day \(dayIndex)"
  }

  // MARK: Body

  var body: some View {
    if dailyJournal.isOriginal {
      originalDailyJournal
    } else {
      VStack(spacing: 0) {
        headerBar
        ContentComposeView(
          index: index, dailyJournal: $dailyJournal,
          isShowingImagePickerSheet: $isShowingImagePickerSheet,
          isDatePickerVisible: $isDatePickerVisible
        )
        .environmentObject(journalComposeVM)
      }
      .padding(.horizontal, 20)
      .padding(.top, 16)
      .padding(.bottom, 24)
      .background(Color.odya.elevation.elev2)
      .cornerRadius(Radius.medium)
      .sheet(isPresented: $isShowingImagePickerSheet) {
        PhotoPickerView(imageList: $dailyJournal.selectedImages, accessStatus: imageAccessStatus)
      }
    }
  }

  // MARK: Header bar
  
  private var originalDailyJournal: some View {
    DailyJournalHeaderBar(dailyJournal: dailyJournal,
                          dayIndexString: dayIndexString)
    .environmentObject(journalComposeVM)
    .padding(.horizontal, 20)
    .padding(.vertical, 16)
    .background(Color.odya.elevation.elev2)
    .clipShape(RoundedEdgeShape(edgeType: .top))
  }
  
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
              journalComposeVM.deleteDailyJournal(dailyJournal: dailyJournal)
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
