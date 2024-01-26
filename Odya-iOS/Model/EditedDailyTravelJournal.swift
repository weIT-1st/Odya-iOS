//
//  DailyTravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/20.
//

import CoreLocation
import SwiftUI

struct ImageData: Identifiable, Hashable {
  var id = UUID()
  var assetIdentifier: String
  var image: UIImage
  var imageName: String = ""
  var creationDate: Date? = nil
  var location: CLLocationCoordinate2D?
  // exif

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension ImageData: Equatable {
  static func == (lhs: ImageData, rhs: ImageData) -> Bool {
    return lhs.assetIdentifier == rhs.assetIdentifier
  }

  static func != (lhs: ImageData, rhs: ImageData) -> Bool {
    return lhs.assetIdentifier != rhs.assetIdentifier
  }
}

struct DailyTravelJournal: Identifiable {
  var id = UUID()

  // data for composing
  var date: Date? = nil
  var content: String = ""
  var selectedImages: [ImageData] = []
  var placeId: String? = nil
  var latitudes: [Double] = []
  var longitudes: [Double] = []

  // data for updating
  var dailyJournalId: Int = -1
  var isOriginal: Bool = false

  func getDayIndex(startDate: Date) -> Int {
    let calendar = Calendar.current
    guard let currentDate = self.date else {
      return 0
    }
    let components = calendar.dateComponents([.day], from: startDate, to: currentDate.addDays(1)!)
    return components.day ?? 0
  }
}

extension DailyTravelJournal: Equatable {
  static func == (lhs: DailyTravelJournal, rhs: DailyTravelJournal) -> Bool {
    return lhs.id == rhs.id
  }

  static func != (lhs: DailyTravelJournal, rhs: DailyTravelJournal) -> Bool {
    return lhs.id != rhs.id
  }

}

extension DailyTravelJournal: Comparable {
  static func < (lhs: DailyTravelJournal, rhs: DailyTravelJournal) -> Bool {
    guard let dateL = lhs.date else {
      return false
    }
    guard let dateR = rhs.date else {
      return true
    }
    return dateL < dateR
  }
}

// MARK: 데일리 일정 임시저장

struct TempDailyJournal: Codable {
  var date: Date?
  var content: String
  var placeId: String?
  
  var dailyJournalId: Int = -1
  var isOriginal: Bool = false
  
  init(from dailyJournal: DailyTravelJournal) {
    self.date = dailyJournal.date
    self.content = dailyJournal.content
    self.placeId = dailyJournal.placeId
    
    self.dailyJournalId = dailyJournal.dailyJournalId
    self.isOriginal = dailyJournal.isOriginal
  }
}

extension DailyTravelJournal {
  func encodeToString() -> String {
    let tempDailyJournal = TempDailyJournal(from: self)
    if let encodedData = try? JSONEncoder().encode(tempDailyJournal) {
      return String(data: encodedData, encoding: .utf8) ?? ""
    }
    return ""
  }
}

extension String {
  func decodeToDailyJournal() -> DailyTravelJournal? {
    if let data = self.data(using: .utf8),
       let decodedData = try? JSONDecoder().decode(TempDailyJournal.self, from: data) {
      return DailyTravelJournal(date: decodedData.date,
                                content: decodedData.content,
                                placeId: decodedData.placeId,
                                dailyJournalId: decodedData.dailyJournalId,
                                isOriginal: decodedData.isOriginal)
    }
    return nil
  }
}
