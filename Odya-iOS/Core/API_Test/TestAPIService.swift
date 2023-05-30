//
//  TestAPIService.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/31.
//

import SwiftUI
import Alamofire

struct TestNetworkResponse: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "hashValue"
        case name = "originalName"
    }
}

enum TestNetworkError: Error {
    case illegalInput
}

final class TestAPIService {
    private let TEST_API_URL = "https://jayden-bin.kro.kr/test"
    
    private let header: HTTPHeaders = [
               "Content-Type" : "application/json"
           ]
    
    func postUsername(name: String) {
        let parameter: Parameters = [
            "name" : name
        ]
        
        AF.request(TEST_API_URL,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
        .responseDecodable(of: TestNetworkResponse.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
