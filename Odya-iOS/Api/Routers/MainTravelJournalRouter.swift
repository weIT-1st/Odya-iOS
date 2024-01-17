//
//  MainTravelJournal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/13.
//

import Foundation
import Moya

// MARK: Main Travel Journal Enum
enum MainTravelJournalRouter {
  // 대표 여행일지 생성
  case createMainJournal(journalId: Int)
  // 내 대표 여행일지 목록 조회
  case getMyMainJournals(size: Int?, lastId: Int?)
  // 다른 사용자 대표 여행일지 목록 조회
  case getOthersMainJournals(userId: Int, size: Int?, lastId: Int?)
  // 대표 여행일지 삭제
  case deleteMainJournal(journalId: Int)
}

extension MainTravelJournalRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case let .createMainJournal(journalId),
      let .deleteMainJournal(journalId):
      return "/api/v1/rep-travel-journals/\(journalId)"
    case .getMyMainJournals:
      return "/api/v1/rep-travel-journals/me"
    case let .getOthersMainJournals(userId, _, _):
      return "/api/v1/rep-travel-journals/\(userId)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createMainJournal:
      return .post
    case .deleteMainJournal:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case let .getMyMainJournals(size, lastId),
      let .getOthersMainJournals(_, size, lastId):
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
