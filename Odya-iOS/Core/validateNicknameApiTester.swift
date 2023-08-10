//
//  validateNicknameApiTester.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/10.
//

import SwiftUI
import Alamofire
import Combine

class validatorApiTestViewModel: ObservableObject {
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

//struct validatorApiTestView: View {
//    let nickname: String = "testNickname"
//    let email: String = "Test@test.com"
//    let phoneNumber: String = "010-9999-9999"
//    
//    @State var isValid: Bool = false
//    var retMessage: String {
//        isValid ? "사용 가능한 닉네임입니다" : "이미 사용 중인 닉네임입니다"
//    }
//    
//    @StateObject var VM = validatorApiTestViewModel()
//    
//    var body: some View {
//        VStack {
//            Text(nickname)
//            Button("중복확인") {
//                VM.validateNickname(nickname: nickname) { result in
//                    isValid = result
//                }
//            }
//            Text(retMessage)
//            
//            Text(email)
//            Button("중복확인") {
//                VM.validateEmail(email: email) { result in
//                    isValid = result
//                }
//            }
//            Text(retMessage)
//            
//            Text(phoneNumber)
//            Button("중복확인") {
//                VM.validatePhonenumber(phoneNumber: phoneNumber) { result in
//                    isValid = result
//                }
//            }
//            Text(retMessage)
//        }
//    }
//}
//
//struct validatorApiTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        validatorApiTestView()
//    }
//}
