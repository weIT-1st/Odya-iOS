//
//  TravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

struct TravelJournalContentImage: Codable {
    var imageId: Int
    var imageName: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageId = "travelJournalContentImageId"
        case imageName = "contentImageName"
        case imageUrl = "contentImageUrl"
    }
}

struct TravelJournalContent: Identifiable, Codable {
    var id = UUID()
    var travelJournalContentId: Int
    var content: String
    var placeId: String?
    var latitudes: [Double]
    var longitudes: [Double]
    var travelDateString: String
    var images: [TravelJournalContentImage]
    
    var travelDate: Date {
        self.travelDateString.toDate(format: "yyyy-MM-dd")!
    }
    
    enum CodingKeys: String, CodingKey {
        case travelJournalContentId
        case content
        case placeId, latitudes, longitudes
        case travelDateString = "travelDate"
        case images = "travelJournalContentImages"
    }
}

struct TravelMateData: Codable {
    var userId: Int?
    var nickname: String?
    var profileUrl: String?
    var isRegistered: Bool
}

struct TravelJournalData: Identifiable, Codable {
    var id = UUID()
    var travelJournalId: Int
    var title: String
    var travelStartDate: String
    var travelEndDate: String
    var visibility: String
    var writer: FollowUserData
    var dailyJournals: [TravelJournalContent]
    var travelMates: [TravelMateData]
    
    enum CodingKeys: String, CodingKey {
        case travelJournalId, title, travelStartDate, travelEndDate, visibility, writer
        case dailyJournals = "travelJournalContents"
        case travelMates = "travleJournalCompanions"
    }
    
    static func getDummy() -> Self {
        return TravelJournalData(travelJournalId: 1,
                                 title: "이번 해에 두 번째 방문하는 돼지런한 서울 여행 기록",
                                 travelStartDate: "2023-06-01",
                                 travelEndDate: "2023-06-04",
                                 visibility: "PUBLIC",
                                 writer:
                                    FollowUserData(userId: 1,
                                                   nickname: "testNickname",
                                                   profile:
                                                    ProfileData(profileUrl: "testAuthenticatedUrl",
                                                                profileColor: ProfileColorData(colorHex: "#ffd42c"))),
                                 dailyJournals: [
                                    TravelJournalContent(
                                        travelJournalContentId: 1,
                                        content: "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.",
                                        latitudes: [],
                                        longitudes: [],
                                        travelDateString: "2023-06-01",
                                        images: []
                                    )
                                 ],
                                 travelMates: [])
    }
}
