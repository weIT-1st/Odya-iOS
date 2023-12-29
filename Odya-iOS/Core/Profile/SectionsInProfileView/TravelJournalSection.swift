//
//  TravelJournalSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/12.
//

import SwiftUI

extension ProfileView {
  
  var mainJournalTitle: some View {
    getSectionTitleView(title: "대표 여행일지",
                        buttonImage: "pen-s",
                        destinationView: .mainJournalRegisterView)
  }
  
  var bookmarkedJournalTitle: some View {
    getSectionTitleView(title: "즐겨찾기 여행일지")
  }
}

struct BookmarkedJournalListinProfileView: View {
  @Binding var path: [StackViewType]
  @StateObject var VM = JournalsInProfileViewModel()
  
  var body: some View {
    ZStack(alignment: .center) {
      if VM.isBookmarkedJournalsLoading {
        ProgressView()
          .frame(height: 200)
          .frame(maxWidth: .infinity)
      }
      
      else {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 8) {
            ForEach(VM.bookmarkedJournals, id: \.id) { journal in
              Button(action: {
                path.append(.journalDetail(journalId: journal.journalId, nickname: journal.writer.nickname))
              }) {
                BookmarkedJournalCardView(journal)
                  .environmentObject(VM)
              }
              .onAppear {
                if let last = VM.lastIdOfBookmarkedJournals,
                   last == journal.bookmarkId {
                  VM.fetchMoreSubject.send()
                }
              }
            }
          }
        }
      }
    }.task {
      await VM.fetchDataAsync()
    }
    .onDisappear {
      VM.initData()
    }
  }
}


