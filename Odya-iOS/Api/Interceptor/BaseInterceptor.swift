//
//  BaseInterceptor.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")

        completion(.success(request))
    }
}
