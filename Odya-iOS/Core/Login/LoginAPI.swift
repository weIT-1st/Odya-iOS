////
////  LoginAPI.swift
////  Odya-iOS
////
////  Created by Heeoh Son on 2023/06/25.
////
//
//import SwiftUI
//import Alamofire
//
//enum LoginType {
//    case kakao
//    case apple
//}
//
//struct KakaoLoginResponse: Codable {
//    // 성공, 유효하고 회원가입된 토큰
//    var firebaseCustomToken : String? = nil
//
//    // 유효하지만 가입되지 않은 토큰
//    var username : String
//    var email : String?
//    var phoneNumber : String?
//    var nickname : String
//    var gender : String?
//
//    // 그 외 에러
//    var errorMessage : String? = nil
//}
//
//
//class KakaoLoginApi: ObservableObject {
//    private let KAKAO_LOGIN_API_URL = "https://jayden-bin.kro.kr/api/v1/auth/login/kakao"
//    private let APPLE_LOGIN_API_URL = "https://jayden-bin.kro.kr/api/v1/auth/login/apple"
//
//    private let header: HTTPHeaders = [
//        "Content-Type" : "application/json"
//    ]
//
//    func postKakaoAuthToken(token: String) {
//        let parameter: Parameters = [
//            "accessToken" : token
//        ]
//
//        AF.request(KAKAO_LOGIN_API_URL,
//                   method: .post,
//                   parameters: parameter,
//                   encoding: JSONEncoding.prettyPrinted,
//                   headers: header)
//        .responseDecodable(of: KakaoLoginResponse.self) { response in
//            switch response.result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error.localizedDescription)
////                if let data = response.data {
////                    let responseJSON = JSON(data)
////                    let errorMessage = responseJSON["errorMessage"].stringValue
////                    print("Error: \(errorMessage)")
////                }
//            }
//        }
//    }
//}
