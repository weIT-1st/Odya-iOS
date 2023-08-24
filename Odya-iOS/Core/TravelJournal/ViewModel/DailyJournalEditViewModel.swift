//
//  DailyJournalEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/22.
//

import SwiftUI

class DailyJournalEditViewModel: ObservableObject {
    @Published var travelJournalEditVM: TravelJournalEditViewModel
//    @Published var dailyJournal: DailyTravelJournal
    @Published var dailyJournalList: [DailyTravelJournal] = []
    
//    init(dailyJournal: DailyTravelJournal) {
//        self.dailyJournal = dailyJournal
//    }
    
    init(travelJournalEditVM: TravelJournalEditViewModel) {
        self.travelJournalEditVM = travelJournalEditVM
    }
    
    func canAddMoreDailyJournals() -> Bool {
        return dailyJournalList.count <= travelJournalEditVM.duration
    }
    
    func addDailyJournal() {
        dailyJournalList.append(DailyTravelJournal())
    }
    
    func deleteDailyJournal(dailyJournal: DailyTravelJournal) {
        dailyJournalList = dailyJournalList.filter{ $0 != dailyJournal }
    }
    
    func setDailyJournalDate(index: Int, selectedDate: Date) {
        dailyJournalList[index].date = selectedDate
    }
}
