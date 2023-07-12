//
//  AuthApiService.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Alamofire
import Combine

/// 인증 관련 api 호출
/// 회원가입, 로그인 (카카오, 애플)
enum AuthApiService {
    static let agent = ApiService()
    
    static func kakaoRegister(username: String,
                              email: String?,
                              phoneNumber: String?,
                              nickname: String,
                              gender: String,
                              birthday: [Int]) -> AnyPublisher<EmptyResponse, APIError> {
//         print("AuthApiService - kakaoRegister() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
         
    }
}


