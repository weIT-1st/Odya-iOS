//
//  TravelJournalRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/15.
//

import Moya
import SwiftUI

// Test
func checkRequestSize(_ formData: [MultipartFormData]) {
  var multipartDataSize: Int = 0

  for multipartData in formData {
    if case .data(let data) = multipartData.provider {
      multipartDataSize += data.count
    }
  }

  print("MultipartFormData 데이터 크기: \(multipartDataSize) bytes")
}

// MARK: Api Request Data
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
  var deleteContentImageIds: [Int]
  var updateImageTotalCount: Int
}

struct TravelJournalRequest: Codable {
  var title: String
  var travelStartDate: [Int]
  var travelEndDate: [Int]
  var visibility: String
  var travelCompanionIds: [Int]
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
  var travelCompanionIds: [Int]
  var travelCompanionNames: [String]
  var travelDurationDays: Int
  var updateTravelCompanionTotalCount: Int
}

// MARK: Travel Journal Enum
enum TravelJournalRouter {
  // 여행일지 생성
  case create(
    token: String,
    title: String,
    startDate: [Int],
    endDate: [Int],
    visibility: String,
    travelMateIds: [Int],
    travelMateNames: [String],
    dailyJournals: [DailyTravelJournal],
    travelDuration: Int,
    imagesTotalCount: Int,
    images: [(data: Data, name: String)])
  // 여행일지 삭제
  case delete(token: String, journalId: Int)
  // 여행일지 기본정보 수정
  case edit(
    token: String, journalId: Int,
    title: String,
    startDate: [Int],
    endDate: [Int],
    visibility: String,
    travelMateIds: [Int],
    travelMateNames: [String],
    travelDuration: Int,
    newTravelMatesCount: Int)
  // 여해일지 데일리 일정 추가
  case createContent(token: String, journalId: Int,
                     content: String,
                     placeId: String?,
                     latitudes: [Double],
                     longitudes: [Double],
                     date: [Int],
                     images: [(data: Data, imageName: String)])
  // 여행일지 데일리 일정 삭제
  case deleteContent(token: String, journalId: Int, contentId: Int)
  // 여행일지 데일리 일정 수정
  case editContent(
    token: String, journalId: Int, contentId: Int,
    content: String,
    placeId: String?,
    latitudes: [Double],
    longitudes: [Double],
    date: [Int],
    newImageNames: [String],
    deletedImageIds: [Int],
    newImageTotalCount: Int,
    images: [(data: Data, name: String)])
  // 함께 간 친구 삭제
  // 태그된 사용자가 태그를 지울때... 사용되는 것 같음.. 아마도
  case deleteTravelMates(token: String, journalId: Int)

  // 여행일지 아이디로 검색
  // 해당 여행일지의 디테일 정보를 모두 가져옴
  case searchById(token: String, journalId: Int)
  // 여행일지 목록 조회
  case getJournals(token: String, size: Int?, lastId: Int?)
  // 내 여행일지 목록 조회
  case getMyJournals(token: String, size: Int?, lastId: Int?, placeId: String? = nil)
  // 친구 여행일지 목록 조회
  case getFriendsJournals(token: String, size: Int?, lastId: Int?, placeId: String? = nil)
  // 추천 여행일지 목록 조회
  case getRecommendedJournals(token: String, size: Int?, lastId: Int?, placeId: String? = nil)
  // 태그된 여행일지 목록 조회
  case getTaggedJournals(token: String, size: Int?, lastId: Int?)

  // 여행일지 북마크 생성(즐겨찾기 추가)
  case createBookmark(token: String, journalId: Int)
  // 즐겨찾기된 여행일지 목록 조회
  case getBookmarkedJournals(token: String, size: Int?, lastId: Int?)
  // 여행일지 북마크 삭제(즐겨찾기 해제)
  case deleteBookmark(token: String, journalId: Int)

  // 여행일지 공개범위 수정
  case updateVisibility(token: String, journalId: Int, visibility: String)
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
      let .delete(_, journalId),
      let .createContent(_, journalId, _, _, _, _, _, _):
      return "/api/v1/travel-journals/\(journalId)"
    case let .editContent(_, journalId, contentId, _, _, _, _, _, _, _, _, _),
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
    case let .createBookmark(_, journalId),
      let .deleteBookmark(_, journalId):
      return "/api/v1/travel-journal-bookmarks/\(journalId)"
    case .getBookmarkedJournals:
      return "/api/v1/travel-journal-bookmarks/me"
    case let .updateVisibility(_, journalId, _):
      return "/api/v1/travel-journals/\(journalId)/visibility"
    }
  }

  var method: Moya.Method {
    switch self {
    case .create, .createBookmark, .createContent:
      return .post
    case .edit, .editContent:
      return .put
    case .delete, .deleteContent, .deleteTravelMates, .deleteBookmark:
      return .delete
    case .updateVisibility:
      return .patch
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case let .create(
      _, title, startDate, endDate, visibility, travelMateIds, travelMateNames, dailyJournals,
      travelDuration, imagesTotalCount, images):

      var travelJournalContents: [TravelJournalContentRequest] = []
      for dailyJournal in dailyJournals {
        travelJournalContents.append(
          TravelJournalContentRequest(
            content: dailyJournal.content,
            placeId: dailyJournal.placeId,
            latitudes: dailyJournal.latitudes,
            longitudes: dailyJournal.longitudes,
            travelDate: dailyJournal.date?.toIntArray() ?? [],
            contentImageNames: dailyJournal.selectedImages.map { $0.imageName + ".webp" }))
      }

      let travelJournal = TravelJournalRequest(
        title: title,
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
        formData.append(
          MultipartFormData(
            provider: .data(travelJournalJSONData), name: "travel-journal",
            fileName: "travel-journal", mimeType: "application/json"))

        for image in images {
          formData.append(
            MultipartFormData(
              provider: .data(image.data), name: "travel-journal-content-image",
              fileName: "\(image.name)", mimeType: "image/webp"))
        }

      } catch {
        print("JSON 인코딩 에러: \(error)")
      }
      // checkRequestSize(formData)
      return .uploadMultipart(formData)
    case let .edit(
      _, _, title, startDate, endDate, visibility, travelMateIds, travelMateNames, travelDuration,
      newTravelMatesCount):
      let newTravelJournal = TravelJournalUpdateRequest(
        title: title,
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
        formData.append(
          MultipartFormData(
            provider: .data(travelJournalJSONData), name: "travel-journal-update",
            fileName: "travel-journal", mimeType: "application/json"))
      } catch {
        print("JSON 인코딩 에러: \(error)")
      }
      return .uploadMultipart(formData)
    case let .createContent(_, _, content, placeId, latitudes, longitudes, date, images):
      let newTravelJournalContent =
      TravelJournalContentRequest(
        content: content,
        placeId: placeId,
        latitudes: latitudes,
        longitudes: longitudes,
        travelDate: date,
        contentImageNames: images.map { $0.imageName })
      var formData: [MultipartFormData] = []
      do {
        let travelJournalJSONData = try JSONEncoder().encode(newTravelJournalContent)
        formData.append(
          MultipartFormData(
            provider: .data(travelJournalJSONData), name: "travel-journal-content",
            fileName: "travel-journal-content", mimeType: "application/json"))

        for image in images {
          formData.append(
            MultipartFormData(
              provider: .data(image.data), name: "travel-journal-content-image",
              fileName: "\(image.imageName)", mimeType: "image/webp"))
        }
      } catch {
        print("JSON 인코딩 에러: \(error)")
      }
      return .uploadMultipart(formData)
    case let .editContent(
      _, _, _, content, placeId, latitudes, longitudes, date, newImageNames, deletedImageIds,
      newImageTotalCount, images):
      let newTravelJournalContent =
        TravelJournalContentUpdateRequest(
          content: content,
          placeId: placeId,
          latitudes: latitudes,
          longitudes: longitudes,
          travelDate: date,
          updateContentImageNames: newImageNames,
          deleteContentImageIds: deletedImageIds,
          updateImageTotalCount: newImageTotalCount)
      var formData: [MultipartFormData] = []
      do {
        let travelJournalJSONData = try JSONEncoder().encode(newTravelJournalContent)
        formData.append(
          MultipartFormData(
            provider: .data(travelJournalJSONData), name: "travel-journal-content-update",
            fileName: "travel-journal", mimeType: "application/json"))

        for image in images {
          formData.append(
            MultipartFormData(
              provider: .data(image.data), name: "travel-journal-content-image-update",
              fileName: "\(image.name)", mimeType: "image/webp"))
        }
      } catch {
        print("JSON 인코딩 에러: \(error)")
      }
      return .uploadMultipart(formData)
    case let .getJournals(_, size, lastId),
      let .getTaggedJournals(_, size, lastId),
      let .getBookmarkedJournals(_, size, lastId):
      var params: [String: Any] = [:]
      if let size = size {
        params["size"] = size
      }
      if let lastId = lastId {
        params["lastId"] = lastId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .getMyJournals(_, size, lastId, placeId),
      let .getFriendsJournals(_, size, lastId, placeId),
      let .getRecommendedJournals(_, size, lastId, placeId):
      var params: [String: Any] = [:]
      if let size = size {
        params["size"] = size
      }
      if let lastId = lastId {
        params["lastId"] = lastId
      }
      params["placeId"] = placeId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .updateVisibility(_, _, visibility):
      let params: [String: Any] = ["visibility": visibility]
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    default:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    switch self {
    case let .create(token, _, _, _, _, _, _, _, _, _, _),
      let .searchById(token, _),
      let .getJournals(token, _, _),
      let .getMyJournals(token, _, _, _),
      let .getFriendsJournals(token, _, _, _),
      let .getRecommendedJournals(token, _, _, _),
      let .getTaggedJournals(token, _, _),
      let .edit(token, _, _, _, _, _, _, _, _, _),
      let .editContent(token, _, _, _, _, _, _, _, _, _, _, _),
      let .createContent(token, _, _, _, _, _, _, _),
      let .delete(token, _),
      let .deleteContent(token, _, _),
      let .deleteTravelMates(token, _),
      let .createBookmark(token, _),
      let .getBookmarkedJournals(token, _, _),
      let .deleteBookmark(token, _),
      let .updateVisibility(token, _, _):
      return ["Authorization": "Bearer \(token)"]
    }
  }

  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }
  
  var validationType: ValidationType {
    return .successCodes
  }

}
