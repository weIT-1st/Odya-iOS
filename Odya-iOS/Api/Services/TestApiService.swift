//
//  TestApiService.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Combine
import Alamofire

/// Test API 호출
enum TestApiService {
    static let agent = ApiService()
    static let base = "https://jayden-bin.kro.kr"
    static let header: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
 
    static func postUsername(username: String) -> AnyPublisher<TestNetworkResponse, APIError> {
        let urlComponents = URLComponents(string: base + "/test")!
        let parameter: Parameters = [
            "name" : username
        ]

        let request = AF.request(urlComponents.url!, method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted, headers: header)
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
