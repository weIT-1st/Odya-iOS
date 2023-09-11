//
//  DailyTravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/20.
//

import SwiftUI
import CoreLocation

struct ImageData: Identifiable, Hashable {
    var id = UUID()
    var assetIdentifier: String
    var image: UIImage
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
  var date: Date? = nil
  var content: String = ""
  var images: [ImageData] = []
  // 사진 리스트
  // 태그된 장소 정보

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
