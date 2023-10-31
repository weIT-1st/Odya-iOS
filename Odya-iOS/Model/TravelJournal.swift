//
//  TravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

//class Writer: Codable {
//    var userId: Int
//    var nickname: String
//    var profile: ProfileData
//}

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

struct TravelMate: Codable {
    var userId: Int?
    var nickname: String?
    var profileUrl: String?
    var isRegistered: Bool
}

struct TravelJournalDetailData: Codable {
    var journalId: Int = -1
    var title: String
    var startDateString: String
    var endDateString: String
    var visibility: String
    var isBookmarked: Bool
    var writer: FollowUserData
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
        case travelMates = "travleJournalCompanions"
    }
}

// 3 - 6. 여행일지 목록 조회
struct travelMateSimple: Codable {
    var username: String
    var profileUrl: String
}

struct TravelJournalData: Codable, Identifiable {
    var id = UUID()
    var journalId: Int
    var title: String
    var content : String
    var imageUrl: String
    var startDateString: String
    var endDateString: String
    var writer: FollowUserData
    var travelMates : [travelMateSimple]
    
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
        case writer
        case travelMates = "travleJournalCompanions"
    }
}

struct TravelJournalList: Codable {
    var hasNext: Bool
    var content: [TravelJournalData]
}

// 7. 태그된 여행일지 목록 조회
struct TaggedJournalData: Codable, Identifiable {
    var id = UUID()
    var journalId : Int
    var title : String
    var startDateString : String
    var mainImageUrl : String
    var writer : FollowUserData
    
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


// 즐겨찾기 여행일지 목록 조회
class BookmarkedJournalData: Codable, Identifiable {
    var id = UUID()
    var bookmarkId: Int
    var journalId : Int
    var title: String
    var startDateString : String
    var mainImageUrl: String
    var writer: FollowUserData
    
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
    }
}

class BookmarkedJournalList: Codable {
    var hasNext: Bool
    var content: [BookmarkedJournalData]
}

//static func getDummy() -> Self {
//    return TravelJournalData(travelJournalId: 1,
//                             title: "이번 해에 두 번째 방문하는 돼지런한 서울 여행 기록",
//                             travelStartDateString: "2023-06-01",
//                             travelEndDateString: "2023-06-04",
//                             visibility: "PUBLIC",
//                             writer:
//                                FollowUserData(userId: 1,
//                                               nickname: "testNickname",
//                                               profile:
//                                                ProfileData(profileUrl: "testAuthenticatedUrl",
//                                                            profileColor: ProfileColorData(colorHex: "#ffd42c"))),
//                             dailyJournals: [
//                                TravelJournalContent(
//                                    travelJournalContentId: 1,
//                                    content: "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.",
//                                    latitudes: [],
//                                    longitudes: [],
//                                    travelDateString: "2023-06-01",
//                                    images: []
//                                )
//                             ],
//                             travelMates: [])
//}
