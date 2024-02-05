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
  @StateObject var bookmarkManager = JournalBookmarkManager()

  let journalId: Int
  let writerNickname: String

  var title: String {
    journalDetailVM.journalDetail?.title ?? ""
  }

  var startDate: Date {
    journalDetailVM.journalDetail?.travelStartDate ?? Date()
  }
  var endDate: Date {
    journalDetailVM.journalDetail?.travelEndDate ?? Date()
  }

  var mates: [TravelMate] {
    journalDetailVM.journalDetail?.travelMates ?? []
  }

  var isBookmarked: Bool {
    journalDetailVM.journalDetail?.isBookmarked ?? false
  }

  var dailyJournals: [DailyJournal] {
    journalDetailVM.journalDetail?.dailyJournals ?? []
  }

  var privacyType: PrivacyType {
    let privacyTypeStr = journalDetailVM.journalDetail?.visibility ?? ""
    return privacyTypeStr.toJournalPrivacyType()
  }

  /// 메뉴 버튼 클릭 시에 메뉴 화면 표시 여부
  @State private var isShowingMeatballMenu: Bool = false

  /// 여행일지 편집 화면 표시 여부
  @State private var isShowingJournalEditView: Bool = false

  /// 데일리 일정 삭제 확인 알림 화면 표시 여부
  @State private var isShowingJournalDeletionAlert: Bool = false

  /// 데일리 일정 삭제 실패 알림 화면 표시 여부
  @State private var isShowingJournalDeletionFailureAlert: Bool = false

  /// 데일리 일정 삭제 실패 시 뜨는 오류 메시지
  @State private var failureMessage: String = ""

  // MARK: Init

  init(journalId: Int, nickname: String = "") {
    self.journalId = journalId
    self.writerNickname = (MyData().nickname == nickname) ? "" : nickname
  }
  //  init(journal: TravelJournalData) {
  //    self.journalId = journal.journalId
  //    let nickname = journal.writer.nickname
  //    self.writerNickname = (MyData().nickname == nickname) ? "" : nickname
  //  }
  //
  //  init(journal: TaggedJournalData) {
  //    self.journalId = journal.journalId
  //    let nickname = journal.writer.nickname
  //    self.writerNickname = (MyData().nickname == nickname) ? "" : nickname
  //    self.startDate = journal.travelStartDate
  //    self.endDate = journal.travelEndDate
  //  }
  //
  //  init(journal: BookmarkedJournalData) {
  //    self.journalId = journal.journalId
  //    let nickname = journal.writer.nickname
  //    self.writerNickname = (MyData().nickname == nickname) ? "" : nickname
  //    self.startDate = journal.travelStartDate
  //    self.endDate = journal.travelEndDate
  //  }

  // MARK: Body

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        let dailyJournals = journalDetailVM.journalDetail?.dailyJournals ?? []
        JournalCardMapView(size: .large, dailyJournals: .constant(dailyJournals))

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
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
      journalDetailVM.isMyJournal = writerNickname == ""
    }
    // 메뉴 버튼 클릭
    .confirmationDialog("", isPresented: $isShowingMeatballMenu) {
      Button("편집") {
        isShowingJournalEditView = true
      }.disabled(journalDetailVM.journalDetail == nil)
      Button("공유") { print("공유 클릭") }
      Button("삭제", role: .destructive) {
        isShowingJournalDeletionAlert = true
      }
      Button("닫기", role: .cancel) { print("닫기 클릭") }
    }
    .fullScreenCover(isPresented: $isShowingJournalEditView) {
      TravelJournalComposeView(
        journalId: journalId,
        title: title,
        startDate: startDate,
        endDate: endDate,
        mates: mates,
        dailyJournals: dailyJournals,
        privacyType: privacyType)
    }
    // 여행일지 삭제 클릭 시 alert
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

  // MARK: Header bar
  private var headerBar: some View {
    VStack {
      ZStack {
        CustomNavigationBar(title: writerNickname)
        HStack(spacing: 8) {
          // 바텀시트 올라와 있을 경우, 백버튼 = 바텀시트 닫기 버튼
          if bottomSheetVM.isSheetOn {
            IconButton("direction-left") {
              withAnimation {
                bottomSheetVM.scrollToTop = true
                bottomSheetVM.sheetOffset = 0
                bottomSheetVM.isSheetOn = false
              }
            }
          }
          Spacer()
          if writerNickname == "" {
            StarButton(isActive: isBookmarked, isYellowWhenActive: true) {
              bookmarkManager.setBookmarkState(isBookmarked, journalId) { newState in
                journalDetailVM.journalDetail?.isBookmarked = newState
              }
            }
            IconButton("menu-meatballs-l") {
              isShowingMeatballMenu = true
            }
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
