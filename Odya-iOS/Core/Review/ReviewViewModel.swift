//
//  ReviewViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/27.
//

import Foundation
import Combine

class ReviewViewModel: ObservableObject {
    // MARK: - Properties
    let testPlaceId = "ChIJE4KVHYqnfDURvqQ3CNzF2Ck" // 테스트 장소 ID
    
    @Published var reviewText = ""  // 한줄리뷰 텍스트
    @Published var showAlert: Bool = false  // Show alert or not
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Helper functions
    
    /**
     # createReview
     - Note: 한줄리뷰 생성
     - Parameters:
        - rating: 별점
        - review: 한줄리뷰 내용
     */
    func createReview(rating: String, review: String) {
        guard let numberOfRating = Int(rating) else {
            alertTitle = "입력 오류"
            alertMessage = "숫자만 입력하세요"
            showAlert = true
            return
        }
        
        ReviewApiService.createReview(placeId: testPlaceId, rating: numberOfRating, review: review)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("DEBUG: 리뷰 작성 완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("ERROR: \(errorData.message)")
                        
                        self.alertTitle = "리뷰 작성 실패"
                        self.alertMessage = errorData.message
                        self.showAlert = true
                    default:
                        debugPrint("ERROR: \(error)")
                        
                        self.alertTitle = "리뷰 작성 실패"
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }
            } receiveValue: { response in
                debugPrint(response)
            }
            .store(in: &cancellables)
    }
    
    /**
     # readPlaceIdReview
     - Note: placeId로 한줄리뷰 가져오기
     */
    func readPlaceIdReview(placeId: String, size: Int?, sortType: String?, lastId: Int?) {
        ReviewApiService.readPlaceIdReview(placeId: placeId, size: size, sortType: sortType, lastId: lastId)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("DEBUG: 리뷰 불러오기 완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("ERROR: \(errorData.message)")
                    default:
                        debugPrint("ERROR: \(error)")
                    }
                }
            } receiveValue: { response in
                let review = response.content
                debugPrint(review)
            }
            .store(in: &cancellables)
    }
    
    /**
     # readUserIdReview
     - Note: userId로 한줄리뷰 가져오기
     */
    func readUserIdReview(userId: Int, size: Int?, sortType: String?, lastId: Int?) {
        ReviewApiService.readUserIdReview(userId: userId, size: size, sortType: sortType, lastId: lastId)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("DEBUG: 리뷰 불러오기 완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("ERROR: \(errorData.message)")
                    default:
                        debugPrint("ERROR: \(error)")
                    }
                }
            } receiveValue: { response in
                let review = response.content
                debugPrint(review)
            }
            .store(in: &cancellables)
    }
    
    /**
     # updateReview
     - Note: 한줄리뷰 수정
     */
    func updateReview(id: Int, rating: Int?, review: String?) {
        ReviewApiService.updateReview(id: id, rating: rating, review: review)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("DEBUG: 리뷰 수정 완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("ERROR: \(errorData.message)")
                    default:
                        debugPrint("ERROR: \(error)")
                    }
                }
            } receiveValue: { response in
                debugPrint(response)
            }
            .store(in: &cancellables)

    }
    
    /**
     # deleteReveiw
     - Note: 한줄리뷰 삭제
     */
    func deleteReveiw(reviewId: Int) {
        ReviewApiService.deleteReview(reviewId: reviewId)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("DEBUG: 리뷰 삭제 완료")
                case .failure(let error):
                    switch error {
                    case .http(let errorData):
                        debugPrint("ERROR: \(errorData.message)")
                    default:
                        debugPrint("ERROR: \(error)")
                    }
                }
            } receiveValue: { response in
                debugPrint(response)
            }
            .store(in: &cancellables)
    }
}
