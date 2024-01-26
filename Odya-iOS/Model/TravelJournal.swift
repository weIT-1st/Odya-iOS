//
//  TravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

// MARK: Daily Journal

struct DailyJournalImage: Codable, Identifiable {
  var id = UUID()
  var imageId: Int
  var imageName: String
  var imageUrl: String

  enum CodingKeys: String, CodingKey {
    case imageId = "travelJournalContentImageId"
    case imageName = "contentImageName"
    case imageUrl = "contentImageUrl"
  }
}

extension DailyJournalImage: Equatable {
  static func == (lhs: DailyJournalImage, rhs: DailyJournalImage) -> Bool {
    return lhs.imageId == rhs.imageId
  }

  static func != (lhs: DailyJournalImage, rhs: DailyJournalImage) -> Bool {
    return lhs.imageId != rhs.imageId
  }
}

struct DailyJournal: Identifiable, Codable {
  var id = UUID()
  var dailyJournalId: Int
  var content: String
  var placeId: String?
  var latitudes: [Double]
  var longitudes: [Double]
  var travelDateString: String
  var images: [DailyJournalImage]

  var travelDate: Date {
    self.travelDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case dailyJournalId = "travelJournalContentId"
    case content
    case placeId, latitudes, longitudes
    case travelDateString = "travelDate"
    case images = "travelJournalContentImages"
  }
}

extension DailyJournal: Equatable {
  static func == (lhs: DailyJournal, rhs: DailyJournal) -> Bool {
    return lhs.id == rhs.id
  }

  static func != (lhs: DailyJournal, rhs: DailyJournal) -> Bool {
    return lhs.id != rhs.id
  }

}

// MARK: Travel Journal

struct TravelJournalDetailData: Codable {
  var journalId: Int = -1
  var title: String
  var startDateString: String
  var endDateString: String
  var visibility: String
  var isBookmarked: Bool
  var writer: Writer
  var dailyJournals: [DailyJournal]
  var travelMates: [TravelMate]

  var travelStartDate: Date {
    self.startDateString.toDate(format: "yyyy-MM-dd")!
  }
  var travelEndDate: Date {
    self.endDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case journalId = "travelJournalId"
    case title
    case startDateString = "travelStartDate"
    case endDateString = "travelEndDate"
    case visibility, isBookmarked, writer
    case dailyJournals = "travelJournalContents"
    case travelMates = "travelJournalCompanions"
  }
}

struct TravelJournalData: Codable, Identifiable {
  var id = UUID()
  var journalId: Int
  var title: String
  var content: String
  var imageUrl: String
  var startDateString: String
  var endDateString: String
  var placeIds: [String]
  var writer: Writer
  var visibility: String
  var travelMates: [travelMateSimple]
  var isBookmarked: Bool

  var travelStartDate: Date {
    self.startDateString.toDate(format: "yyyy-MM-dd")!
  }
  var travelEndDate: Date {
    self.endDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case journalId = "travelJournalId"
    case title, content
    case imageUrl = "contentImageUrl"
    case startDateString = "travelStartDate"
    case endDateString = "travelEndDate"
    case placeIds
    case writer
    case visibility = "visibility"
    case travelMates = "travelCompanionSimpleResponses"
    case isBookmarked
  }
}

struct TravelJournalList: Codable {
  var hasNext: Bool
  var content: [TravelJournalData]
}

// MARK: Tagged Journal

// 7. 태그된 여행일지 목록 조회
struct TaggedJournalData: Codable, Identifiable {
  var id = UUID()
  var journalId: Int
  var title: String
  var startDateString: String
  var mainImageUrl: String
  var writer: Writer

  var travelStartDate: Date {
    self.startDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case journalId = "travelJournalId"
    case title
    case startDateString = "travelStartDate"
    case mainImageUrl, writer
  }
}

struct TaggedJournalList: Codable {
  var hasNext: Bool
  var content: [TaggedJournalData]
}

// MARK: Bookmarked Journal

// 즐겨찾기 여행일지 목록 조회
class BookmarkedJournalData: Codable, Identifiable {
  var id = UUID()
  var bookmarkId: Int
  var journalId: Int
  var title: String
  var startDateString: String
  var mainImageUrl: String
  var writer: Writer
  var isBookmarked: Bool

  var travelStartDate: Date {
    self.startDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case bookmarkId = "travelJournalBookmarkId"
    case journalId = "travelJournalId"
    case title
    case startDateString = "travelStartDate"
    case mainImageUrl = "travelJournalMainImageUrl"
    case writer
    case isBookmarked
  }
}

class BookmarkedJournalList: Codable {
  var hasNext: Bool
  var content: [BookmarkedJournalData]
}

// MARK: Main Travel Journal

class MainJournalData: Codable, Identifiable {
  var id = UUID()
  var repJournalId: Int
  var journalId: Int
  var title: String
  var content: String
  var startDateString: String
  var endDateString: String
  var mainImageUrl: String
  var writer: Writer
  var travelMates: [travelMateSimple]

  var travelStartDate: Date {
    self.startDateString.toDate(format: "yyyy-MM-dd")!
  }
  var travelEndDate: Date {
    self.endDateString.toDate(format: "yyyy-MM-dd")!
  }

  private enum CodingKeys: String, CodingKey {
    case repJournalId = "repTravelJournalId"
    case journalId = "travelJournalId"
    case title
    case content
    case startDateString = "travelStartDate"
    case endDateString = "travelEndDate"
    case mainImageUrl = "travelJournalMainImageUrl"
    case writer
    case travelMates = "travelCompanionSimpleResponses"
  }
}

class MainJournalList: Codable {
  var hasNext: Bool
  var content: [MainJournalData]
}
