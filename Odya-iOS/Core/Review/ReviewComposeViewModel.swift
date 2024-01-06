//
//  ReviewComposeViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import Combine
import Moya
import SwiftUI

/// 한줄리뷰 작성 뷰모델
final class ReviewComposeViewModel: ObservableObject {
  // MARK: Properties

  /// 리뷰 내용 텍스트
  @Published var reviewText: String = ""
  /// 별점
  @Published var rating: Double = 0.0
  
  // Networking
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var reviewProvider = MoyaProvider<ReviewRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // MARK: Helper functions
  
  func validate() -> Bool {
    if reviewText.isEmpty || rating == 0.0 {
      return false
    } else if reviewText.count > 30 {
      return false
    } else {
      return true
    }
  }
  
  /// 리뷰 생성
  func createReview(placeId: String) {
    let rating = Int(self.rating * 2)
    
    reviewProvider.requestPublisher(.createReview(placeId: placeId, rating: rating, review: reviewText))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("한줄리뷰 생성 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData)
          }
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}
