//
//  CommunityRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/05.
//

import Foundation
import Moya

enum CommunityRouter {
  // 1. 생성
  case createCommunity(content: String, visibility: String, placeId: String?, travelJournalId: Int?, topicId: Int?, images: [(data: Data, name: String)])
  // 2. 상세 조회
  case getCommunityDetail(communityId: Int)
  // 3. 전체 목록 조회
  case getAllCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 4. 나의 목록 조회
  case getMyCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 5. 친구 목록 조회
  case getFriendsCommunity(size: Int?, lastId: Int?, sortType: String?)
  // 6. 토픽으로 전체 목록 조회
  case getAllCommunityByTopic(size: Int?, lastId: Int?, sortType: String?, topicId: Int)
  // 7. 좋아요 누른 목록 조회
  // 8. 댓글 단 목록 조회
  // 9. 수정
  // 10. 삭제
  case deleteCommunity(communityId: Int)
}

extension CommunityRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var path: String {
    switch self {
    case .createCommunity:
        return "/api/v1/communities"
    case .getCommunityDetail(let communityId):
      return "/api/v1/communities/\(communityId)"
    case .getAllCommunity:
      return "/api/v1/communities"
    case .getMyCommunity:
      return "/api/v1/communities/me"
    case .getFriendsCommunity:
      return "/api/v1/communities/friends"
    case .getAllCommunityByTopic(_, _, _, let topicId):
      return "/api/v1/communities/topic/\(topicId)"
    case .deleteCommunity(let communityId):
      return "/api/v1/communities/\(communityId)"
    }
  }

  var method: Moya.Method {
      switch self {
      case .getCommunityDetail, .getAllCommunity, .getMyCommunity, .getFriendsCommunity, .getAllCommunityByTopic:
          return .get
      case .createCommunity:
          return .post
      case .deleteCommunity:
          return .delete
      }
  }

  var task: Moya.Task {
    switch self {
    case .createCommunity(let content, let visibility, let placeId, let travelJournalId, let topicId, let images):
        var formData = [MultipartFormData]()
        var body: [String: Any] = [:]
        body["content"] = content
        body["visibility"] = visibility
        body["placeId"] = placeId
        body["travelJournalId"] = travelJournalId
        body["topicId"] = topicId
        let encodedBody = try? JSONSerialization.data(withJSONObject: body)
        formData.append(MultipartFormData(provider: .data(encodedBody ?? Data()), name: "community", fileName: "community", mimeType: "application/json"))
        for image in images {
            formData.append(MultipartFormData(provider: .data(image.data), name: "community-content-image", fileName: "\(image.name).webp", mimeType: "image/webp"))
        }
        return .uploadMultipart(formData)
    case .getCommunityDetail:
      return .requestPlain
    case .getAllCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .getMyCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .getFriendsCommunity(let size, let lastId, let sortType):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .getAllCommunityByTopic(let size, let lastId, let sortType, _):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      params["sortType"] = sortType
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    case .deleteCommunity:
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
