//
//  validateNicknameApiTester.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/10.
//

import SwiftUI
import Alamofire
import Combine

class AuthValidatorApiViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    func validateNickname(nickname: String, completion: @escaping (Bool) -> Void) {
        AuthApiService.validateNickname(value: nickname)
            .sink{ apiCompletion in
                switch apiCompletion {
                case .finished:
                    print("닉네임 중복확인 완료")
                    completion(true)
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        print("Error: \(errorData.message)")
                    default:
                        print("Error: unknown error")
                    }
                    completion(false)
                }
            } receiveValue: { response in
                debugPrint(response)
            }.store(in: &subscription)
    }
    
    func validateEmail(email: String, completion: @escaping (Bool) -> Void) {
        AuthApiService.validateEmail(value: email)
            .sink{ apiCompletion in
                switch apiCompletion {
                case .finished:
                    print("이메일 중복확인 완료")
                    completion(true)
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        print("Error: \(errorData.message)")
                    default:
                        print("Error: unknown error")
                    }
                    completion(false)
                }
            } receiveValue: { response in
                debugPrint(response)
            }.store(in: &subscription)
    }
    
    func validatePhonenumber(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        AuthApiService.validatePhonenumber(value: phoneNumber)
            .sink{ apiCompletion in
                switch apiCompletion {
                case .finished:
                    print("핸드폰 번호 중복확인 완료")
                    completion(true)
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        print("Error: \(errorData.message)")
                    default:
                        print("Error: unknown error")
                    }
                    completion(false)
                }
            } receiveValue: { response in
                debugPrint(response)
            }.store(in: &subscription)
    }
}
