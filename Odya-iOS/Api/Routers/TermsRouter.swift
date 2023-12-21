//
//  TermsRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/13.
//

import Foundation
import Moya

enum TermsRouter {
  case getTermsList
  case getTermsContent(termsId: Int)
}

extension TermsRouter: TargetType {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .getTermsList:
      return "/api/v1/auth/terms"
    case .getTermsContent(let termsId):
      return "/api/v1/auth/terms/\(termsId)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getTermsList, .getTermsContent:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .getTermsList:
      return .requestPlain
    case .getTermsContent:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }

}
