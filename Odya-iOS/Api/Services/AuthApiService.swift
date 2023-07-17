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
        // print("AuthApiService - kakaoRegister() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.kakaoRegister(username: username, email: email, phoneNumber: phoneNumber, nickname: nickname, gender: gender, birthday: birthday))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func appleRegister(idToken: String,
                              email: String?,
                              nickname: String,
                              phoneNumber: String?,
                              gender: String,
                              birthday : [Int]) -> AnyPublisher<EmptyResponse, APIError> {
        // print("AuthApiService - appleRegister() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.appleRegister(idToken: idToken, email: email, nickname: nickname, phoneNumber: phoneNumber, gender: gender, birthday: birthday))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func kakaoLogin(accessToken: String) -> AnyPublisher<KakaoTokenResponse, APIError> {
        print("AuthApiService - kakaoLogin() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.kakaoLogin(accessToken: accessToken))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func appleLogin(idToken: String) -> AnyPublisher<EmptyResponse, APIError> {
        // print("AuthApiService - appleLogin() called")
        
        let request = ApiClient.shared.session.request(AuthRouter.appleLogin(idToken: idToken))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

