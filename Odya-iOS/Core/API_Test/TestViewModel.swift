//
//  TestViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/01.
//

import Foundation
import Combine

class TestViewModel: ObservableObject {
    // MARK: - Properties
    let shared = ApiService()
    private var cancellableSet: Set<AnyCancellable> = []
    
    // MARK: - Helpers
    func submitUsername(username: String) {
        TestApiService.postUsername(username: username)
            .sink { completion in
                switch completion {
                case .finished:
                    print("완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("에러: \(errorData.message)")
                    default:
                        debugPrint("Unknown Error")
                    }
                }
            } receiveValue: { response in
                debugPrint("성공: \(response.id), \(response.name)")
            }.store(in: &cancellableSet)
    }
}
