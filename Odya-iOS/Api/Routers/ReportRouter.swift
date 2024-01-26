//
//  ReportRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/17.
//

import Foundation
import Moya

enum ReportRouter {
  // 1. 한줄리뷰 신고
  case reportPlaceReview(placeReviewId: Int, reportReason: String, otherReason: String?)
  // 2. 여행일지 신고
  case reportTravelJournal(travelJournalId: Int, reportReason: String, otherReason: String?)
  // 3. 커뮤니티 신고
  case reportCommunity(communityId: Int, reportReason: String, otherReason: String?)
}

extension ReportRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .reportPlaceReview:
      return "/api/v1/reports/place-review"
    case .reportTravelJournal:
      return "/api/v1/reports/travel-journal"
    case .reportCommunity:
      return "/api/v1/reports/community"
    }
  }

  var method: Moya.Method {
    return .post
  }

  var task: Moya.Task {
    switch self {
    case .reportPlaceReview(let placeReviewId, let reportReason, let otherReason):
      var params: [String: Any] = [:]
      params["placeReviewId"] = placeReviewId
      params["reportReason"] = reportReason
      params["otherReason"] = otherReason
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    case .reportTravelJournal(let travelJournalId, let reportReason, let otherReason):
      var params: [String: Any] = [:]
      params["travelJournalId"] = travelJournalId
      params["reportReason"] = reportReason
      params["otherReason"] = otherReason
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    case .reportCommunity(let communityId, let reportReason, let otherReason):
      var params: [String: Any] = [:]
      params["communityId"] = communityId
      params["reportReason"] = reportReason
      params["otherReason"] = otherReason
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }

  var authorizationType: Moya.AuthorizationType? {
    return .bearer
  }

  var validationType: ValidationType {
    return .successCodes
  }
}
