//
//  ApiClient.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/10.
//

import Foundation
import Alamofire

final class ApiClient {
    static let shared = ApiClient()
    
    static let BASE_URL = "https://jayden-bin.kro.kr"
    
    // request 보낼 때 필요한 정보들 끼워넣는 역할
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
    ])
    
    let monitors = [ApiLogger()] as [EventMonitor]
    
    var session: Session
    
    init() {
        print("ApiClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
}
