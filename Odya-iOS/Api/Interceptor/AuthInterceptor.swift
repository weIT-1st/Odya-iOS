//
//  AuthInterceptor.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/25.
//

import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {

  static let shared = AuthInterceptor()
  var appDataManager = AppDataManager()

  private init() {}

  //    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
  //    }

  func retry(
    _ request: Request, for session: Session, dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    print("Retry networking...")
    guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
    else {
      completion(.doNotRetryWithError(error))
      return
    }

    /// 토큰 갱신 및 유저 정보 가져오기
    Task {
      do {
        if await appDataManager.refreshToken() {
          let _ = try await appDataManager.initMyData()
          print("토큰 갱신 끝! retry 시작!")
          //                    completion(.retry)
          completion(.retryWithDelay(3))
        }
      } catch {
        print("Data initialzing failed with error:", error)
        completion(.doNotRetryWithError(error))
      }
    }
  }
}
