//
//  AuthRouter.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Alamofire
import Foundation

// 인증 라우터
// 회원가입(애플, 카카오)
enum AuthRouter: URLRequestConvertible {
  case appleLogin(idToken: String)
  case kakaoLogin(accessToken: String)
  case appleRegister(
    idToken: String,
    email: String?,
    phoneNumber: String?,
    nickname: String,
    gender: String,
    birthday: [Int],
    termsIdList: [Int])
  case kakaoRegister(
    username: String,
    email: String?,
    phoneNumber: String?,
    nickname: String,
    gender: String,
    birthday: [Int],
    termsIdList: [Int])
  case validateNickname(value: String)
  case validateEmail(value: String)
  case validatePhonenumber(value: String)

  var baseURL: URL {
    return URL(string: ApiClient.BASE_URL)!
  }

  var endPoint: String {
    switch self {
    case .appleLogin:
      return "/api/v1/auth/login/apple"
    case .kakaoLogin:
      return "/api/v1/auth/login/kakao"
    case .appleRegister:
      return "/api/v1/auth/register/apple"
    case .kakaoRegister:
      return "/api/v1/auth/register/kakao"
    case .validateNickname:
      return "/api/v1/auth/validate/nickname"
    case .validateEmail:
      return "/api/v1/auth/validate/email"
    case .validatePhonenumber:
      return "/api/v1/auth/validate/phone-number"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .validateNickname, .validateEmail, .validatePhonenumber:
      return .get
    default:
      return .post
    }
  }

  var parameters: Parameters {
    switch self {
    case let .appleLogin(idToken):
      let params: Parameters = ["idToken": idToken]
      return params
    case let .kakaoLogin(accessToken):
      let params: Parameters = ["accessToken": accessToken]
      return params
    case let .appleRegister(idToken, email, phoneNumber, nickname, gender, birthday, termsIdList):
      var params = Parameters()
      params["idToken"] = idToken
      params["email"] = email
      params["phoneNumber"] = phoneNumber
      params["nickname"] = nickname
      params["gender"] = gender
      params["birthday"] = birthday
      params["termsIdList"] = termsIdList
      return params
    case let .kakaoRegister(username, email, phoneNumber, nickname, gender, birthday, termsIdList):
      var params = Parameters()
      params["username"] = username
      params["email"] = email
      params["phoneNumber"] = phoneNumber
      params["nickname"] = nickname
      params["gender"] = gender
      params["birthday"] = birthday
      params["termsIdList"] = termsIdList
      return params
    case .validateNickname(let value), .validateEmail(let value), .validatePhonenumber(let value):
      return ["value": value]
    }
  }

  func asURLRequest() throws -> URLRequest {
    var url: URL
    switch self {
    case .validateNickname, .validateEmail, .validatePhonenumber:
      var urlComponents = URLComponents(
        url: baseURL.appendingPathComponent(endPoint), resolvingAgainstBaseURL: true)!
      urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
      url = urlComponents.url!
    default:
      url = baseURL.appendingPathComponent(endPoint)
    }
    print(url)

    var request = URLRequest(url: url)
    request.method = method
    if request.method == .post {
      request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
    }

    return request
  }

}
