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
