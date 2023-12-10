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
  // 2. 이메일 변경
  case updateUserEmailAddress(newEmailAddr: String)
  // 3. 전화번호 변경
  case updateUserPhoneNumber(newPhoneNumber: String)
  // 4. 닉네임 변경
  case updateUserNickname(newNickname: String)
  // 5. 사용자 프로필 사진 변경
  case updateUserProfileImage(profileImg: (data: Data, name: String)?)
  // 7. 회원탈퇴
  case deleteUser
  // 8. 유저 검색
  case searchUser(size: Int?, lastId: Int?, nickname: String)
  // 9. 사용자 통계 조회
  case getUserStatistics(userId: Int)
}

extension UserRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .updateUserEmailAddress:
      return "/api/v1/users/email"
    case .updateUserPhoneNumber:
      return "/api/v1/users/phone-number"
    case .getUserInfo:
      return "/api/v1/users/me"
    case .updateUserNickname:
      return "/api/v1/users/information"
    case .updateUserProfileImage:
      return "/api/v1/users/profile"
    case .deleteUser:
      return "/api/v1/users"
    case .searchUser:
      return "/api/v1/users/search"
    case .getUserStatistics(let userId):
      return "/api/v1/users/\(userId)/statistics"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .updateUserEmailAddress,
        .updateUserPhoneNumber,
        .updateUserNickname,
        .updateUserProfileImage:
      return .patch
    case .deleteUser:
      return .delete
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .updateUserNickname(let newNickname):
      let params: [String : Any] = ["nickname" : newNickname]
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
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
