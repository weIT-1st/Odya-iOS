//
//  MainJournalSelectorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/12.
//

import SwiftUI

struct MainJournalSelectorView: View {
  @EnvironmentObject var VM: JournalsInProfileViewModel

  @Binding var path: NavigationPath

  let orgMainJournal: MainJournalData?

  @State private var selectedJournalId: Int? = nil
  @State private var selectedJournalTitle: String? = nil

  @Environment(\.dismiss) private var dismiss

  // 기존 대표 여행일지와 다른 새로운 여행일지를 선택했는지 여부
  var isSelected: Bool {
    orgMainJournal?.journalId ?? nil != selectedJournalId
  }

  var body: some View {
    ZStack(alignment: .top) {
      LinkedTravelJournalView(
        selectedJournalId: $selectedJournalId,
        selectedJournalTitle: $selectedJournalTitle, headerTitle: "")

      headerBar
    }
    .onAppear {
      selectedJournalId = orgMainJournal?.journalId ?? nil
      selectedJournalTitle = orgMainJournal?.title ?? nil
    }
  }

  private var headerBar: some View {
    HStack {
      IconButton(isSelected ? "x" : "direction-left") {
        selectedJournalId = nil
        selectedJournalTitle = nil
        dismiss()
      }
      .frame(width: 36, height: 36)
      Spacer()
      Text("대표 여행일지")
        .h6Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      if isSelected {
        Button {
          // 대표 여행이지 설정 api
          VM.setMainJournal(
            orgMainJournalId: orgMainJournal?.journalId ?? nil,
            journalId: selectedJournalId
          ) {
            dismiss()
          }
          // 실패 시
          // alert를 띄워야 하나
        } label: {
          Text("완료")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
            .frame(width: 36, height: 36)
        }
      } else {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 36, height: 36)
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
    .background(Color.odya.background.normal)
  }

}
