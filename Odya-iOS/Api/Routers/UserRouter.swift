//
//  UserRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation
import Moya

enum UserRouter {
  // 1. 사용자 정보 조회
    case getUserInfo
  // 5. 사용자 프로필 사진 변경
  case updateUserProfileImage(profileImg: (data: Data, name: String)?)
  // 7. 회원탈퇴
  case deleteUser
  // 8. 유저 검색
  case searchUser(size: Int?, lastId: Int?, nickname: String)
  // 9. 사용자 통계 조회
  case getUserStatistics(userId: Int)
  // 10. 사용자 인생샷 조회
  case getPOTDList(userId: Int, size: Int?, lastId: Int?)
}

extension UserRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .getUserInfo:
      return "/api/v1/users/me"
    case .updateUserProfileImage:
      return "/api/v1/users/profile"
    case .deleteUser:
      return "/api/v1/users"
    case .searchUser:
      return "/api/v1/users/search"
    case .getUserStatistics(let userId):
      return "/api/v1/users/\(userId)/statistics"
    case let .getPOTDList(userId, _, _):
      return "/api/v1/users/\(userId)/life-shots"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .updateUserProfileImage:
      return .patch
    case .deleteUser:
      return .delete
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
    case .searchUser(let size, let lastId, let nickname):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["nickname"] = nickname
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case let .getPOTDList(_, size, lastId):
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
