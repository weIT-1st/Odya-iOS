//
//  ReviewRouter.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/07/22.
//

import SwiftUI
import Alamofire

// 한줄리뷰 라우터
// 한줄리뷰 CRUD

enum ReviewRouter: URLRequestConvertible {
    // MARK: - ID Token 대입
    
    var idToken: String {
        return "Firebase Id Token"
    }
    
    // MARK: - Cases
    
    case createReview(placeId: String, rating: Int, review: String)
    case readPlaceIdReview(placeId: String, size: Int?, sortType: String?, lastId: Int?)
    case readUserIdReview(userId: Int, size: Int?, sortType: String?, lastId: Int?)
    case updateReview(id: Int, rating: Int?, review: String?)
    case deleteReview(reviewId: Int)
    
    // MARK: - Properties
    
    var baseURL: String {
        return "https://jayden-bin.kro.kr"
    }
    
    var header: HTTPHeaders {
        return [.authorization(bearerToken: idToken)]
    }
    
    var endPoint: String {
        switch self {
        case let .readPlaceIdReview(placeId, _, _, _):
            return "/api/v1/place-reviews/places/" + "\(placeId)"
        case let .readUserIdReview(userId, _, _, _):
            return "/api/v1/place-reviews/users/" + "\(userId)"
        case let .deleteReview(reviewId):
            return "/api/v1/place-reviews/" + "\(reviewId)"
        default:
            return "/api/v1/place-reviews"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        case .updateReview:
            return .patch
        case .deleteReview:
            return .delete
        case .readPlaceIdReview, .readUserIdReview:
            return .get
        }
    }
    
    var parameter: Parameters {
        switch self {
        case let .createReview(placeId, rating, review):
            var params = Parameters()
            params["placeId"] = placeId
            params["rating"] = rating
            params["review"] = review
            return params
        case let .updateReview(id, rating, review):
            var params = Parameters()
            params["id"] = id
            params["rating"] = rating
            params["review"] = review
            return params
        case .deleteReview(_):
            var params = Parameters()
            return params
        case let .readPlaceIdReview(_, size, sortType, lastId):
            var params = Parameters()
            params["size"] = size
            params["sortType"] = sortType
            params["lastId"] = lastId
            return params
        case let .readUserIdReview(_, size, sortType, lastId):
            var params = Parameters()
            params["size"] = size
            params["sortType"] = sortType
            params["lastId"] = lastId
            return params
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!.appendingPathComponent(endPoint)
        
        var request = URLRequest(url: url)

        switch self {
        case .createReview, .updateReview, .deleteReview:
            request.httpBody = try JSONEncoding.prettyPrinted.encode(request, with: parameter).httpBody
        case .readPlaceIdReview, .readUserIdReview:
            request = try URLEncoding.queryString.encode(request, with: parameter)
        }
        
        request.method = method
        request.headers = header
        
        return request
    }
}
