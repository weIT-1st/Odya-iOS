//
//  CommunityCommentRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/14.
//

import Foundation
import Moya

enum CommunityCommentRouter {
  // 1. 댓글 생성
  case createComment(communityId: Int, content: String)
  // 2. 댓글 목록 조회
  case getComment(communityId: Int, size: Int?, lastId: Int?)
  // 3. 댓글 수정
  case patchComment(communityId: Int, commentId: Int, content: String)
  // 4. 댓글 삭제
  case deleteComment(communityId: Int, commentId: Int)
}

extension CommunityCommentRouter: TargetType, AccessTokenAuthorizable {
  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }
  
  var path: String {
    switch self {
    case .createComment(let communityId, _):
      return "/api/v1/communities/\(communityId)/comments"
    case .getComment(let communityId, _, _):
      return "/api/v1/communities/\(communityId)/comments"
    case .patchComment(let communityId, let commentId, _):
      return "/api/v1/communities/\(communityId)/comments/\(commentId)"
    case .deleteComment(let communityId, let commentId):
      return "/api/v1/communities/\(communityId)/comments/\(commentId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .createComment:
      return .post
    case .getComment:
      return .get
    case .patchComment:
      return .patch
    case .deleteComment:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .createComment(_, let content):
      var params: [String: Any] = [:]
      params["content"] = content
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
      
    case .getComment(_, let size, let lastId):
      var params: [String: Any] = [:]
      params["size"] = size
      params["lastId"] = lastId
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .patchComment(_, _, let content):
      var params: [String: Any] = [:]
      params["content"] = content
      return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
      
    case .deleteComment:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
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
