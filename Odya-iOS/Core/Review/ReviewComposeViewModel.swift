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
  @Published var isProgressing: Bool = false
  @Published var isPosted: Bool = false
  
  // alert
  @Published var alertTitle: String = ""
  @Published var alertMessage: String = ""
  @Published var showAlert: Bool = false
  
  // MARK: Helper functions
  
  func validate() -> Bool {
    if reviewText.count > 30 {
      DispatchQueue.main.async {
        self.reviewText.removeLast()
      }
    }
    
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
    isProgressing = true
    let rating = Int(self.rating * 2)
    
    reviewProvider.requestPublisher(.createReview(placeId: placeId, rating: rating, review: reviewText))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("한줄리뷰 생성 완료")
          self.isPosted = true
        case .failure(let error):
          self.handleErrorData(error: error)
        }
        self.isProgressing = false
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  func handleErrorData(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      alertTitle = "Error \(errorData.code)"
      alertMessage = errorData.message
      showAlert = true
    } else {
      alertTitle = "Unknown Error!"
      alertMessage = "알 수 없는 오류 발생"
      showAlert = true
    }
  }
}
