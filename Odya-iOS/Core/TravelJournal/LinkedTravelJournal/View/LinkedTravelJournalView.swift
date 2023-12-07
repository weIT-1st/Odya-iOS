//
//  LinkedTravelJournalView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import SwiftUI

struct LinkedTravelJournalView: View {
  // MARK: Properties
  @StateObject private var viewModel = LinkedTravelJournalViewModel()
  
  // MARK: Body
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.state.content, id: \.journalId) { content in
          LinkedTravelJournalCell(content: content)
            .onAppear {
              if viewModel.state.content.last?.journalId == content.journalId {
                viewModel.fetchMyJournalListNextPageIfPossible()
              }
            }
        }
      }
      .task {
        viewModel.fetchMyJournalListNextPageIfPossible()
      }
    }
  }
}

// MARK: - Previews
struct LinkedTravelJournalView_Previews: PreviewProvider {
  static var previews: some View {
    LinkedTravelJournalView()
  }
}
