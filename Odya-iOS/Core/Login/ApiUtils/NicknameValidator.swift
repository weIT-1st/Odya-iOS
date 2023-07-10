//
//  NicknameValidator.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/26.
//

import SwiftUI
import Alamofire
import Combine
import SwiftyJSON

struct EmptyResponse: Codable { }

struct ErrorResponse: Codable {
    let errorMessage: String
}

class NicknameValidator: ObservableObject {
    
    @Published var isChecking = false
    @Published var errorMessage : String? = nil
    
    private let baseUrl = "https://jayden-bin.kro.kr"
    
    private let header: HTTPHeaders = [
        "Content-Type" : "application/json;charset=UTF-8"
    ]
    
    func getNicknameValidation(_ nickname: String) {
        
        let url = "\(baseUrl)/api/v1/auth/validate/nickname?value=\(nickname)"
        
        isChecking = true
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: EmptyResponse.self) { response in
            self.isChecking = false
            
            switch response.result {
            case .success:
                self.errorMessage = nil
            case .failure(let error):
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                        self.isDuplicate = true
                        self.errorMessage = errorResponse.errorMessage
                        print(errorResponse.errorMessage)
                    } catch {
                        self.errorMessage = "Error! 다시 중복 확인 버튼을 눌러주세요"
                        print("Failed to decode failure response: \(error)")
                    }
                } else {
                    self.errorMessage = "Error! 다시 중복 확인 버튼을 눌러주세요"
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
