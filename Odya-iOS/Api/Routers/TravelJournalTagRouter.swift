//
//  TravelJournalTagRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import Foundation
import Moya

enum TravelJournalTagRouter {
  // 7. 태그된 여행일지 목록 조회
  case getTaggedJournals(size: Int?, lastId: Int?)
  // 12. 함께 간 친구 삭제
  // 태그된 사용자가 태그를 지울때... 사용
  case deleteTravelMates(journalId: Int)
}

extension TravelJournalTagRouter: TargetType, AccessTokenAuthorizable {

  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .getTaggedJournals:
      return "/api/v1/travel-journals/tagged"
    case let .deleteTravelMates(journalId):
      return "/api/v1/travel-journals/\(journalId)/travelCompanion"

    }
  }

  var method: Moya.Method {
    switch self {
    case .deleteTravelMates:
      return .delete
    default:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {

    case let .getTaggedJournals(size, lastId):
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
