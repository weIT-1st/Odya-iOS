//
//  UserRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation
import Moya

enum UserRouter {
  // 사용자 정보 조회
    case getUserInfo
  // 사용자 통계 조회
  case getUserStatistics(userId: Int)
  // 사용자 프로필 사진 변경
  case updateUserProfileImage(profileImg: (data: Data, name: String)?)
}

extension UserRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .getUserInfo:
      return "/api/v1/users/me"
    case .getUserStatistics(let userId):
      return "/api/v1/users/\(userId)/statistics"
    case .updateUserProfileImage:
      return "/api/v1/users/profile"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .updateUserProfileImage:
      return .patch
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .updateUserProfileImage(let profileImg):
      guard let profileImg = profileImg else {
        return .requestPlain
      }
      var formData: [MultipartFormData] = []
      formData.append(MultipartFormData(provider: .data(profileImg.data), name: "profile", fileName: "\(profileImg.name)", mimeType: "image/webp"))
      return .uploadMultipart(formData)
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
