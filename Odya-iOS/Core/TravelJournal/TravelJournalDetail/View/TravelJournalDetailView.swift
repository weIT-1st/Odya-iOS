//
//  TravelJournalDetailView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/26.
//

import SwiftUI

struct TravelJournalDetailView: View {
  @Environment(\.dismiss) var dismiss

  @StateObject var bottomSheetVM = BottomSheetViewModel()
  @StateObject var journalDetailVM = TravelJournalDetailViewModel()

  let journalId: Int

  @State private var isShowingMeatballMenu: Bool = false

  /// 데일리 일정 삭제 확인 알림 화면 표시 여부
  @State private var isShowingJournalDeletionAlert: Bool = false

  /// 데일리 일정 삭제 실패 알림 화면 표시 여부
  @State private var isShowingJournalDeletionFailureAlert: Bool = false

  /// 데일리 일정 삭제 실패 시 뜨는 오류 메시지
  @State private var failureMessage: String = ""

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        // TODO: map
        Color.odya.brand.primary
          .ignoresSafeArea()

        headerBar

        if let journalDetail = journalDetailVM.journalDetail {
          JournalDetailBottomSheet(travelJournal: journalDetail)
            .environmentObject(bottomSheetVM)
            .environmentObject(journalDetailVM)
            .frame(height: UIScreen.main.bounds.height)
            .offset(y: bottomSheetVM.minHeight)
            .offset(y: bottomSheetVM.sheetOffset)
            .gesture(
              DragGesture()
                .onChanged { value in
                  withAnimation {
                    if !bottomSheetVM.isSheetOn && bottomSheetVM.isScrollAtTop {
                      bottomSheetVM.sheetOffset = value.translation.height
                    }
                  }
                }
                .onEnded { value in
                  withAnimation {
                    if !bottomSheetVM.isSheetOn || bottomSheetVM.isScrollAtTop {
                      bottomSheetVM.setSheetHeight(value, geometry)
                    }
                  }

                }
            )
        } else {
          VStack {
            Spacer()
            ProgressView()
              .frame(height: 250)
          }
        }

        if let journal = journalDetailVM.journalDetail,
          let editedJournal = journalDetailVM.editedDailyJournal
        {
          DailyJournalEditView(journal: journal, editedJournal: editedJournal)
            .environmentObject(journalDetailVM)
        }
      }  // geometry
    }
    .onAppear {
      journalDetailVM.getJournalDetail(journalId: journalId)
      bottomSheetVM.isSheetOn = false
    }
    .confirmationDialog("", isPresented: $isShowingMeatballMenu) {
      Button("공유") { print("공유 클릭") }
      // Button("수정") { print("수정 클릭") }
      Button("삭제", role: .destructive) {
        isShowingJournalDeletionAlert = true
      }
      Button("닫기", role: .cancel) { print("닫기 클릭") }
    }
    .alert("해당 여행일지를 삭제할까요?", isPresented: $isShowingJournalDeletionAlert) {
      HStack {
        Button("취소", role: .cancel) {
          isShowingJournalDeletionAlert = false
        }
        Button("삭제", role: .destructive) {
          isShowingJournalDeletionAlert = false
          journalDetailVM.deleteJournal(journalId: journalId) { success, errMsg in
            if success {
              print("delete")
              dismiss()
            } else {
              failureMessage = errMsg
              isShowingJournalDeletionFailureAlert = true
            }

          }
        }
      }
    } message: {
      Text("삭제된 내용은 복구될 수 없습니다.")
    }
    .alert(failureMessage, isPresented: $isShowingJournalDeletionFailureAlert) {
      Button("확인") {
        isShowingJournalDeletionFailureAlert = false
        failureMessage = ""
      }
    }

  }

  private var headerBar: some View {
    VStack {
      ZStack {
        CustomNavigationBar(title: "")
        HStack(spacing: 8) {
          // 바텀시트 올라와 있을 경우, 백버튼 = 바텀시트 닫기 버튼
          if bottomSheetVM.isSheetOn {
            IconButton("direction-left") {
              withAnimation {
                bottomSheetVM.sheetOffset = 0
                bottomSheetVM.isSheetOn = false
              }
            }
          }
          Spacer()
          IconButton("star-off") {
            // print("clicked")
          }
          IconButton("menu-meatballs-l") {
            isShowingMeatballMenu = true
          }
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
      }

      Spacer()
    }
  }

}

struct TravelJournalDetailView_Previews: PreviewProvider {
  static var previews: some View {
    MyJournalsView()
    // TravelJournalDetailView(journalId: 1)
  }
}
