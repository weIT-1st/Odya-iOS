//
//  TravelJournalRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/15.
//

import SwiftUI
import Moya

enum TravelJournalRouter {
    case create(token: String, journal: TravelJournalData, images: [UIImage])
    case searchById(token: String, journalId: Int)
    case getJournals(token: String, size: Int?, lastId: Int?)
    case getMyJournals(token: String, size: Int?, lastId: Int?)
    case getFriendsJournals(token: String, size: Int?, lastId: Int?)
    case getRecommendedJournals(token: String, size: Int?, lastId: Int?)
    case getTaggedJournals(token: String, size: Int?, lastId: Int?)
    case edit(token: String, journalId: Int)
    case editContent(token: String, journalId: Int, contentId: Int)
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
            let .edit(_, journalId),
            let .delete(_, journalId):
            return "/api/v1/travel-journals/\(journalId)"
        case let .editContent(_, journalId, contentId),
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
        case let .create(_, journal, images):
            var params: [String: Any] = [:]
            params["title"] = journal.title
            params["travelStartDate"] = journal.travelStartDate
            params["travelEndDate"] = journal.travelEndDate
            params["visibility"] = journal.visibility
            params["travelCompanionIds"] = journal.travelMates.map { $0.userId }
//            params["travelJournalContentRequests"] =
//            travelJournalContentRequests(List<Object>): 여행 일지 콘텐츠 목록(Not Null) travelJournalContentRequests.content(String): 여행 일지 콘텐츠 내용(Nullable) travelJournalContentRequests.placeId(String): 여행 일지 콘텐츠 장소 아이디(Nullable) travelJournalContentRequests.latitudes(List<Double>): 여행 일지 콘텐츠 위도 목록(Nullable) travelJournalContentRequests.longitudes(List<Double>): 여행 일지 콘텐츠 경도 목록(Nullable) travelJournalContentRequests.travelDate(String): 여행 일지 콘텐츠 일자(Not Null) travelJournalContentRequests.contentImageNames(List<String>): 여행 일지 콘텐츠 사진 제목 + 형식(Not NULL)
            
            var multipartData = [MultipartFormData]()
//            let jsonType = try? JSONEncoder().encode(params)
//            let formData = MultipartFormData(provider: .data(jsonType!), name: "travel-journal", fileName: "travel-journal", mimeType: "application/json")
//            multipartData.append(formData)
//
//            for (index, image) in images.enumerated() {
//                multipartData.append(MultipartFormData(provider: .data(images), name: "travel-journal-content-image", fileName: "example_file\(index).webp", mimeType: "image/webp"))
//            }
            return .uploadMultipart(multipartData)
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
        case let .create(token, _, _),
            let .searchById(token, _),
            let .getJournals(token, _, _),
            let .getMyJournals(token, _, _),
            let .getFriendsJournals(token, _, _),
            let .getRecommendedJournals(token, _, _),
            let .getTaggedJournals(token, _, _),
            let .edit(token, _),
            let .editContent(token, _, _),
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
