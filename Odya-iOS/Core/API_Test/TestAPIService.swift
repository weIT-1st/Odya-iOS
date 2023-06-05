//
//  TestAPIService.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/31.
//

import SwiftUI
import Alamofire
import SwiftyJSON

// MARK: - Model
/**
 테스트 API를 통해 이름을 전달한 뒤, 해시값과 이름을 받아 저장하는 모델
 - id: Hash Value
 - name: Original Name
 */
struct TestNetworkResponse: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "hashValue"
        case name = "originalName"
    }
}

// MARK: - Networking

/// 테스트 API와 네트워크 통신하는 서비스
final class TestAPIService {
    private let TEST_API_URL = "https://jayden-bin.kro.kr/test"
    
    private let header: HTTPHeaders = [
        "Content-Type" : "application/json"
    ]
    
    /**
     POST: 유저 이름을 테스트 서버에 제출
     - Alamofire를 통해 request. body를 JSON으로 인코딩해 전달
     - 성공시, TestNetworkResonse 타입으로 디코딩한 데이터 출력
     - 실패시, 서버에서 전달받은 에러 메시지 출력
     - Parameter name: 유저 이름
     */
    func postUsername(name: String) {
        let parameter: Parameters = [
            "name" : name
        ]
        
        AF.request(TEST_API_URL,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header)
        .responseDecodable(of: TestNetworkResponse.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
                if let data = response.data {
                    let responseJSON = JSON(data)
                    let errorMessage = responseJSON["errorMessage"].stringValue
                    print("Error: \(errorMessage)")
                }
            }
        }
    }
}
