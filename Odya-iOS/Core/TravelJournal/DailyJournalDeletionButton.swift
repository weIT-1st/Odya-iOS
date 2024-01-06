//
//  DailyJournalDeletionButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/06.
//

import SwiftUI
    
struct DailyJournalDeletionButton: View {
  @StateObject var VM = DailyJournalDeletionButtonViewModel()
  
  let journalId: Int
  let dailyJournalId: Int
  @Binding var isDeleted: Bool
  
  @State private var isShowingAlert: Bool = false
  
  var body: some View {
    Button(action: {
      isShowingAlert = true
    }) {
      Text("삭제하기")
        .font(Font.custom("Noto Sans KR", size: 14))
        .underline()
        .foregroundColor(.odya.label.assistive)
    }.padding(.trailing, 8)
      .alert("해당 날짜의 여행일지를 삭제할까요?", isPresented: $isShowingAlert) {
        HStack {
          Button("취소", role: .cancel) {
            isShowingAlert = false
          }
          Button("삭제", role: .destructive) {
            isShowingAlert = false
            print("delete daily journal")
            isDeleted = true
            // original -> delete api
//            VM.deleteDailyJournal(journalId: journalId, dailyJournalId: dailyJournalId) { success, _ in
//              self.isDeleted = success
//            }
          }
        }
      } message: {
        Text("삭제된 내용은 복구될 수 없습니다.")
      }
  }
}
