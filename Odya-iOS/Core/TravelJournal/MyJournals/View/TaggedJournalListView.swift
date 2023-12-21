//
//  TaggedJournalListView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import SwiftUI

struct TaggedJournalListView: View {
  @EnvironmentObject var VM: TaggedJournalListViewModel
  @EnvironmentObject var bookmarkedJournalsVM: BookmarkedJournalListViewModel

  var body: some View {
    ZStack(alignment: .center) {
      if VM.isTaggedJournalsLoading
        && VM.taggedJournals.isEmpty
      {
        ProgressView()
          .frame(height: 224)
          .frame(maxWidth: .infinity)
      } else {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 10) {
            ForEach(VM.taggedJournals, id: \.id) { journal in
              linkToJournalDetail(journal)
                .onAppear {
                  if let last = VM.lastIdOfTaggedJournals,
                    last == journal.journalId
                  {
                    VM.fetchMoreTaggedJournalsSubject.send()
                  }
                }
            }  // ForEach
          }
        }  // ScrollView
      }
    }  // ZStack
  }

  private func linkToJournalDetail(_ journal: TaggedJournalData) -> some View {
    NavigationLink(
      destination: TravelJournalDetailView(
        journalId: journal.journalId, nickname: journal.writer.nickname
      )
      .navigationBarHidden(true)
    ) {
      TravelJournalSmallCardView(
        title: journal.title, date: journal.travelStartDate, imageUrl: journal.mainImageUrl,
        writer: journal.writer)
    }
    .overlay {
      TaggedJournalCardOverlayMenuView(journalId: journal.journalId)
        .environmentObject(VM)
        .environmentObject(bookmarkedJournalsVM)
    }
  }
}
