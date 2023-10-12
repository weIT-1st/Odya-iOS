//
//  DailyJournalViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

class DailyJournalViewModel: ObservableObject {
  @Published var isExpanded: Bool = false
  // var dailyJournal: DailyTravelJournal

  func setExpansionState(to state: Bool) {
    self.isExpanded = state
  }

  func switchExpansionState() {
    self.isExpanded.toggle()
  }
}
