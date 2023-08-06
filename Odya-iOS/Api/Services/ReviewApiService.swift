//
//  ReviewApiService.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/27.
//

import Foundation
import Alamofire
import Combine

/// 한줄리뷰 api 호출
/// 생성, 조회, 수정, 삭제
enum ReviewApiService {
    static let agent = ApiService()
    
    /// 생성
    static func createReview(placeId: String, rating: Int, review: String) -> AnyPublisher<EmptyResponse, APIError> {
        
        let request = ApiClient.shared.session.request(ReviewRouter.createReview(placeId: placeId, rating: rating, review: review))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    /// 장소 ID 리뷰 조회
    static func readPlaceIdReview(placeId: String, size: Int?, sortType: String?, lastId: Int?) -> AnyPublisher<Review, APIError> {
        
        let request = ApiClient.shared.session.request(ReviewRouter.readPlaceIdReview(placeId: placeId, size: size, sortType: sortType, lastId: lastId))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    /// 유저 ID 리뷰 조회
    static func readUserIdReview(userId: Int, size: Int?, sortType: String?, lastId: Int?) -> AnyPublisher<Review, APIError> {
        
        let request = ApiClient.shared.session.request(ReviewRouter.readUserIdReview(userId: userId, size: size, sortType: sortType, lastId: lastId))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    /// 수정
    static func updateReview(id: Int, rating: Int?, review: String?) -> AnyPublisher<EmptyResponse, APIError> {
        
        let request = ApiClient.shared.session.request(ReviewRouter.updateReview(id: id, rating: rating, review: review))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    /// 삭제
    static func deleteReview(reviewId: Int) -> AnyPublisher<EmptyResponse, APIError> {
        
        let request = ApiClient.shared.session.request(ReviewRouter.deleteReview(reviewId: reviewId))
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
