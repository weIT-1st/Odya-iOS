//
//  LinkedTravelJournalView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import SwiftUI

struct LinkedTravelJournalView: View {
  // MARK: Properties
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = LinkedTravelJournalViewModel()
  /// 선택된 여행일지 아이디
  @State private var selectedJournalId: Int? = nil
  
  // MARK: Body
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
        Section {
          ForEach(viewModel.state.content, id: \.journalId) { content in
            Button {
              if selectedJournalId == content.journalId {
                selectedJournalId = nil
              } else {
                selectedJournalId = content.journalId
              }
            } label: {
              LinkedTravelJournalCell(content: content, selectedId: $selectedJournalId)
                .onAppear {
                  if viewModel.state.content.last?.journalId == content.journalId {
                    viewModel.fetchMyJournalListNextPageIfPossible()
                  }
                }
            }
          }
        } header: {
          header
            .padding(.bottom, 21)
        }
      }
      .toolbar(.hidden)
      .task {
        viewModel.fetchMyJournalListNextPageIfPossible()
      }
    } // ScrollView
    .background(Color.odya.background.normal)
    .clipped()
  }
  
  /// 상단 헤더
  private var header: some View {
    HStack {
      IconButton("x") {
        dismiss()
      }
      .frame(width: 36, height: 36)
      Spacer()
      Text("여행일지")
        .h6Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      if selectedJournalId != nil {
        Button {
          dismiss()
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

// MARK: - Previews
struct LinkedTravelJournalView_Previews: PreviewProvider {
  static var previews: some View {
    LinkedTravelJournalView()
  }
}
