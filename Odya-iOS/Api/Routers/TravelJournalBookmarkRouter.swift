//
//  TravelJournalBookmarkRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import Foundation
import Moya

// MARK: Travel Journal Bookmark Enum
enum TravelJournalBookmarkRouter {
  // 여행일지 북마크 생성(즐겨찾기 추가)
  case createBookmark(journalId: Int)
  // 즐겨찾기된 여행일지 내 목록 조회
  case getMyBookmarkedJournals(size: Int?, lastId: Int?)
  // 즐겨찾기된 여행일지 다른 사용자 목록 조회
  case getOthersBookmarkedJournals(userId: Int, size: Int?, lastId: Int?)
  // 여행일지 북마크 삭제(즐겨찾기 해제)
  case deleteBookmark(journalId: Int)
}

extension TravelJournalBookmarkRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case let .createBookmark(journalId),
      let .deleteBookmark(journalId):
      return "/api/v1/travel-journal-bookmarks/\(journalId)"
    case .getMyBookmarkedJournals:
      return "/api/v1/travel-journal-bookmarks/me"
    case let .getOthersBookmarkedJournals(userId, _, _):
      return "/api/v1/travel-journal-bookmarks/\(userId)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createBookmark:
      return .post
    case .deleteBookmark:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case let .getMyBookmarkedJournals(size, lastId),
      let .getOthersBookmarkedJournals(_, size, lastId):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    default:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    switch self {
    default:
      return ["Content-type": "application/json"]
    }
  }

  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }

  var validationType: ValidationType {
    return .successCodes
  }

}
