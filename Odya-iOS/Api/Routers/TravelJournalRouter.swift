//
//  TravelJournalRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/15.
//

import SwiftUI
import Moya

struct TravelJournalContentRequest: Codable {
    var content: String
    var placeId: String?
    var latitudes: [Double]
    var longitudes: [Double]
    var travelDate: [Int]
    var contentImageNames: [String]
}

struct TravelJournalContentUpdateRequest: Codable {
    var content: String
    var placeId: String?
    var latitudes: [Double]
    var longitudes: [Double]
    var travelDate: [Int]
    var updateContentImageNames: [String]
    var deleteContentImageIds: [Int64]
    var contentImageNames: [String]
    var updateImageTotalCount: Int
}

struct TravelJournalRequest: Codable {
    var title: String
    var travelStartDate: [Int]
    var travelEndDate: [Int]
    var visibility: String
    var travelCompanionIds: [Int64]
    var travelCompanionNames: [String]
    var travelJournalContentRequests: [TravelJournalContentRequest]
    var travelDurationDays: Int
    var contentImageNameTotalCount: Int
}

struct TravelJournalUpdateRequest: Codable {
    var title: String
    var travelStartDate: [Int]
    var travelEndDate: [Int]
    var visibility: String
    var travelCompanionIds: [Int64]
    var travelCompanionNames: [String]
    var travelDurationDays: Int
    var updateTravelCompanionTotalCount: Int
}


enum TravelJournalRouter {
    case create(token: String,
                title: String,
                startDate: [Int],
                endDate: [Int],
                visibility: String,
                travelMateIds: [Int64],
                travelMateNames: [String],
                dailyJournals: [DailyTravelJournal],
                travelDuration: Int,
                imagesTotalCount: Int,
                images: [(data: Data, name: String)])
    case searchById(token: String, journalId: Int)
    case getJournals(token: String, size: Int?, lastId: Int?)
    case getMyJournals(token: String, size: Int?, lastId: Int?)
    case getFriendsJournals(token: String, size: Int?, lastId: Int?)
    case getRecommendedJournals(token: String, size: Int?, lastId: Int?)
    case getTaggedJournals(token: String, size: Int?, lastId: Int?)
    case edit(token: String, journalId: Int,
              title: String,
              startDate: [Int],
              endDate: [Int],
              visibility: String,
              travelMateIds: [Int64],
              travelMateNames: [String],
              travelDuration: Int,
              newTravelMatesCount: Int)
    case editContent(token: String, journalId: Int, contentId: Int,
                     content: String,
                     placeId: String?,
                     latitudes: [Double],
                     longitudes: [Double],
                     date: [Int],
                     newImageNames: [String],
                     deletedImageIds: [Int64],
                     imageNames: [String],
                     newImageTotalCount: Int,
                     images: [(data: Data, name: String)])
    case delete(token: String, journalId: Int)
    case deleteContent(token: String, journalId: Int, contentId: Int)
    case deleteTravelMates(token: String, journalId: Int)

}

extension TravelJournalRouter: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .create, .getJournals:
            return "/api/v1/travel-journals"
        case let .searchById(_, journalId),
            let .edit(_, journalId, _, _, _, _, _, _, _, _),
            let .delete(_, journalId):
            return "/api/v1/travel-journals/\(journalId)"
        case let .editContent(_, journalId, contentId, _, _, _, _, _, _, _, _, _, _),
            let .deleteContent(_, journalId, contentId):
            return "/api/v1/travel-journals/\(journalId)/\(contentId)"
        case let .deleteTravelMates(_, journalId):
            return "/api/v1/travel-journals/\(journalId)/travelCompanion"
        case .getMyJournals:
            return "/api/v1/travel-journals/me"
        case .getFriendsJournals:
            return "/api/v1/travel-journals/friends"
        case .getRecommendedJournals:
            return "/api/v1/travel-journals/recommends"
        case .getTaggedJournals:
            return "/api/v1/travel-journals/tagged"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .edit, .editContent:
            return .put
        case .delete, .deleteContent, .deleteTravelMates:
            return .delete
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            // TODO: Create, Edit, EditContent
        case let .create(_, title, startDate, endDate, visibility, travelMateIds, travelMateNames, dailyJournals, travelDuration, imagesTotalCount, images):
            
            var travelJournalContents: [TravelJournalContentRequest] = []
            for dailyJournal in dailyJournals {
                travelJournalContents.append(
                    TravelJournalContentRequest(content: dailyJournal.content,
                                                latitudes: dailyJournal.latitudes,
                                                longitudes: dailyJournal.longitudes,
                                                travelDate: dailyJournal.date?.toIntArray() ?? [],
                                                contentImageNames: dailyJournal.images.map{ $0.imageName }))
            }
            
            var travelJournal = TravelJournalRequest(title: title,
                                                     travelStartDate: startDate,
                                                     travelEndDate: endDate,
                                                     visibility: visibility,
                                                     travelCompanionIds: travelMateIds,
                                                     travelCompanionNames: travelMateNames,
                                                     travelJournalContentRequests: travelJournalContents,
                                                     travelDurationDays: travelDuration,
                                                     contentImageNameTotalCount: imagesTotalCount)
            var formData: [MultipartFormData] = []
            do {
                let travelJournalJSONData = try JSONEncoder().encode(travelJournal)
                formData.append(MultipartFormData(provider: .data(travelJournalJSONData), name: "travel-journal", fileName: "travel-journal", mimeType: "application/json"))
                
                for image in images {
                    formData.append(MultipartFormData(provider: .data(image.data), name: "travel-journal-content-image", fileName: "\(image.name).webp", mimeType: "image/webp"))
                }
            } catch {
                print("JSON 인코딩 에러: \(error)")
            }
            return .uploadMultipart(formData)
        case let .edit(_, _, title, startDate, endDate, visibility, travelMateIds, travelMateNames, travelDuration, newTravelMatesCount):
            var newTravelJournal = TravelJournalUpdateRequest(title: title,
                                                     travelStartDate: startDate,
                                                     travelEndDate: endDate,
                                                     visibility: visibility,
                                                     travelCompanionIds: travelMateIds,
                                                     travelCompanionNames: travelMateNames,
                                                     travelDurationDays: travelDuration,
                                                     updateTravelCompanionTotalCount: newTravelMatesCount)
            var formData: [MultipartFormData] = []
            do {
                let travelJournalJSONData = try JSONEncoder().encode(newTravelJournal)
                formData.append(MultipartFormData(provider: .data(travelJournalJSONData), name: "travel-journal-update", fileName: "travel-journal", mimeType: "application/json"))
            } catch {
                print("JSON 인코딩 에러: \(error)")
            }
            return .uploadMultipart(formData)
        case let .editContent(_, _, _, content, placeId, latitudes, longitudes, date, newImageNames, deletedImageIds, imageNames, newImageTotalCount, images):
            var newTravelJournalContent =
            TravelJournalContentUpdateRequest(content: content,
                                              placeId: placeId,
                                              latitudes: latitudes,
                                              longitudes: longitudes,
                                              travelDate: date,
                                              updateContentImageNames: newImageNames,
                                              deleteContentImageIds: deletedImageIds,
                                              contentImageNames: imageNames,
                                              updateImageTotalCount: newImageTotalCount)
            var formData: [MultipartFormData] = []
            do {
                let travelJournalJSONData = try JSONEncoder().encode(newTravelJournalContent)
                formData.append(MultipartFormData(provider: .data(travelJournalJSONData), name: "travel-journal-content-image-update", fileName: "travel-journal", mimeType: "application/json"))
                
                for image in images {
                    formData.append(MultipartFormData(provider: .data(image.data), name: "travel-journal-content-image-update", fileName: "\(image.name).webp", mimeType: "image/webp"))
                }
            } catch {
                print("JSON 인코딩 에러: \(error)")
            }
            return .uploadMultipart(formData)
        case let .getJournals(_, size, lastId),
            let .getMyJournals(_, size, lastId),
            let .getFriendsJournals(_, size, lastId),
            let .getRecommendedJournals(_, size, lastId),
            let .getTaggedJournals(_, size, lastId):
            var params: [String: Any] = [:]
            if let size = size {
                params["size"] = size
            }
            if let lastId = lastId {
                params["lastId"] = lastId
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .create(token, _, _, _, _, _, _, _, _, _, _),
            let .searchById(token, _),
            let .getJournals(token, _, _),
            let .getMyJournals(token, _, _),
            let .getFriendsJournals(token, _, _),
            let .getRecommendedJournals(token, _, _),
            let .getTaggedJournals(token, _, _),
            let .edit(token, _, _, _, _, _, _, _, _, _),
            let .editContent(token, _, _, _, _, _, _, _, _, _, _, _, _),
            let .delete(token, _),
            let .deleteContent(token, _, _),
            let .deleteTravelMates(token, _):
            return ["Authorization" : "Bearer \(token)"]
        }
    }
    
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
    
    
}
