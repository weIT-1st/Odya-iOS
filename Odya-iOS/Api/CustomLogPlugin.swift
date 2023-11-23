//
//  CustomLogPlugin.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/23.
//

import Foundation
import Moya

final class CustomLogPlugin: PluginType {
  /// API를 보내기 직전에 호출
  func willSend(_ request: RequestType, target: TargetType) {
    let headers = request.request?.allHTTPHeaderFields ?? [:]
    let url = request.request?.url?.absoluteString ?? "nil"
    if let body = request.request?.httpBody {
      let bodyString = String(bytes: body, encoding: String.Encoding.utf8) ?? "nil"
      print("""
              <willSend - \(Date().debugDescription)>
              url: \(url)
              headers : \(headers)
              body: \(bodyString)
      """)
    } else {
      print("""
              <willSend - \(Date().debugDescription)>
              url: \(url)
              headers : \(headers)
              body: nil
      """)
    }
  }

  /// API Response
  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    let response = try? result.get()
    let request = try? result.get().request
    let url = request?.url?.absoluteString ?? "nil"
    let method = request?.httpMethod ?? "nil"
    let statusCode = response?.statusCode ?? 0
    var bodyString = "nil"
    if let data = request?.httpBody, let string = String(bytes: data, encoding: String.Encoding.utf8) {
      bodyString = string
    }
    var responseString = "nil"
    if let data = response?.data, let reString = String(bytes: data, encoding: String.Encoding.utf8) {
      responseString = reString
    }
    print("""
            <didReceive - \(method) statusCode: \(statusCode)>
            url: \(url)
            body: \(bodyString)
            response: \(responseString)
    """)
  }
}
