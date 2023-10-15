//
//  TravelJournalEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/22.
//

import SwiftUI

class TravelJournalEditViewModel: ObservableObject {
    
  @Published var title: String = ""
  @Published var startDate = Date()
  @Published var endDate = Date()
  @Published var travelMates: [FollowUserData] = []
  @Published var dailyJournalList: [DailyTravelJournal] = []

  @Published var pickedJournalIndex: Int? = nil

  var duration: Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    return components.day ?? 0
  }

  // MARK: Functions - travel dates

  func setTravelDates(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }

  func setJournalDate(selectedDate: Date) {
    if let idx = self.pickedJournalIndex {
      self.dailyJournalList[idx].date = selectedDate
    }
  }

  // MARK: Functions - register

  func validateTravelJournal() -> Bool {
    return true
  }

  func registerTravelJournal() {
    print("여행일지 등록하기 버튼 클릭")
  }

  // MARK: Functions - daily journal

  func canAddMoreDailyJournals() -> Bool {
    return dailyJournalList.count <= duration
  }

  func addDailyJournal(date: Date? = nil) {
    if let date = date {
      dailyJournalList.append(DailyTravelJournal(date: date))
    } else {
      dailyJournalList.append(DailyTravelJournal())
    }
  }

  func deleteDailyJournal(dailyJournal: DailyTravelJournal) {
    dailyJournalList = dailyJournalList.filter { $0 != dailyJournal }
  }

}
