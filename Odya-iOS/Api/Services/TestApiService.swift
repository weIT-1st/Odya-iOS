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
 
    static func postUsername(username: String) -> AnyPublisher<TestNetworkResponse, APIError> {

//        let request = AF.request(urlComponents.url!, method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted, headers: header)
        let request = ApiClient.shared.session.request(TestRouter.postUsername(username: username))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
