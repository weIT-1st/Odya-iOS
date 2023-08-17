//
//  ApiService.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Alamofire
import Combine


struct ApiService {
  
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { result -> Response<T> in
                debugPrint(result)
                let statusCode = result.response?.statusCode ?? 0
                
                switch statusCode {
                case 200, 201, 204:
                    guard let data = result.data else { // 응답이 성공이고 result가 없을 때 Empty를 리턴
                        return Response(value: EmptyResponse() as! T, response: result.response!)
                    }
                    let value = try decoder.decode(T.self, from: data)
                    return Response(value: value, response: result.response!)
                case 400...500:
                    guard let errorData = result.data else {
                        throw APIError.unknown
                    }
                    guard let value = try? decoder.decode(ErrorData.self, from: errorData) else {
                        throw APIError.unknown
                    }
                    
                    if value.code == -10005 { // Unregistered user
                        guard let kakaoErrorValue = try? decoder.decode(KakaoLoginErrorResponse.self, from: errorData) else {
                            throw APIError.http(value)
                        }
                        throw APIError.unauthorizedToken(kakaoErrorValue)
                    } else {
                        throw APIError.http(value)
                    }
                    
                default:
                    throw APIError.unknown
                }
            }
            .mapError({ (error) -> APIError in
                // print("error: \(error.localizedDescription)")
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknown
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
