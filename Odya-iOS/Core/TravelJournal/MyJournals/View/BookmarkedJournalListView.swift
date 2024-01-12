//
//  BookmarkedJournalListView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import SwiftUI

struct BookmarkedJournalListView: View {
  @EnvironmentObject var VM: BookmarkedJournalListViewModel

  var body: some View {
    ZStack(alignment: .center) {
      if VM.isBookmarkedJournalsLoading
        && VM.bookmarkedJournals.isEmpty
      {
        ProgressView()
          .frame(height: 224)
          .frame(maxWidth: .infinity)
      }

      else {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 10) {
            ForEach(VM.bookmarkedJournals, id: \.id) { journal in
              linkToJournalDetail(journal: journal)
                .onAppear {
                  if let last = VM.lastIdOfBookmarkedJournals,
                    last == journal.bookmarkId
                  {
                    VM.fetchMoreBookmarkedJournalsSubject.send()
                  }
                }
            }  // ForEach
          }  // LazyHStack
        }  // ScrollView
      }
    }  // ZStack
  }

  private func linkToJournalDetail(journal: BookmarkedJournalData) -> some View {
    NavigationLink(
      destination: TravelJournalDetailView(
        journalId: journal.journalId, nickname: journal.writer.nickname
      )
      .navigationBarHidden(true)
    ) {
      TravelJournalSmallCardView(
        title: journal.title, date: journal.travelStartDate, imageUrl: journal.mainImageUrl,
        writer: journal.writer)
    }.overlay {
      FavoriteJournalCardOverlayMenuView(journalId: journal.journalId,
                                         isBookmarked: journal.isBookmarked)
        .environmentObject(VM)
    }
  }

}
