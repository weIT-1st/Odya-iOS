//
//  ReviewViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import Combine
import Moya
import SwiftUI

/// 한줄리뷰 작성 뷰모델
final class ReviewViewModel: ObservableObject {
  // MARK: Properties
  
  // Networking
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var reviewProvider = MoyaProvider<ReviewRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private lazy var reportProvider = MoyaProvider<ReportRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  @Published var isProgressing: Bool = false
  @Published var isPosted: Bool = false
  @Published var needToRefresh: Bool = false
  
  // for view
  struct ReviewState {
    var content: [Review] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  @Published private(set) var reviewState = ReviewState()
  
  @Published var isReviewExisted: Bool? = nil
  @Published var reviewCount: Int? = nil
  @Published var averageStarRating: Double = 0.0
  @Published var myReview: Review? = nil
  
  // alert
  @Published var alertTitle: String = ""
  @Published var alertMessage: String = ""
  @Published var showAlert: Bool = false
  
  // MARK: Helper functions
  
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
  
  // MARK: Read
  /// 한줄리뷰 관련 조회
  func fetchReviewInfo(placeId: String) {
    fetchIfReviewExist(placeId: placeId)
    fetchReviewCount(placeId: placeId)
    fetchAverageStarRating(placeId: placeId)
  }
  
  /// 한줄리뷰 작성 여부 조회
  private func fetchIfReviewExist(placeId id: String) {
    reviewProvider.requestPublisher(.getIfReviewExist(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("리뷰 작성 여부 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewExistResponse.self) {
          self.isReviewExisted = data.exist
        }
      }
      .store(in: &subscription)
  }
  
  /// 한줄리뷰 개수 조회
  private func fetchReviewCount(placeId id: String) {
    reviewProvider.requestPublisher(.getReviewCount(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("리뷰 수 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewCountResponse.self) {
          self.reviewCount = data.count
        }
      }
      .store(in: &subscription)
  }
  
  /// 리뷰 평균 별점 조회
  private func fetchAverageStarRating(placeId id: String) {
    reviewProvider.requestPublisher(.getAverageStarRating(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("평균 별점 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewAverageStarRatingResponse.self) {
          self.averageStarRating = data.averageStarRating / 2
        }
      }
      .store(in: &subscription)
  }
  
  func refreshAllReviewContent(placeId: String, sortType: String) {
    fetchReviewInfo(placeId: placeId)
    self.reviewState = ReviewState()
    fetchReviewByPlaceNextPageIfPossible(placeId: placeId, sortType: sortType)
  }
  
  func sortReivew(placeId: String, sortType: String) {
    self.reviewState = ReviewState()
    fetchReviewByPlaceNextPageIfPossible(placeId: placeId, sortType: sortType)
  }
  
  func fetchReviewByPlaceNextPageIfPossible(placeId: String, sortType: String) {
    guard reviewState.canLoadNextPage else { return }
    if placeId.isEmpty { return }
    
    reviewProvider.requestPublisher(.readPlaceIdReview(placeId: placeId, size: nil, sortType: sortType, lastId: reviewState.lastId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("장소 리뷰 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewListResponse.self) {
          self.reviewState.content = data.content
          self.reviewState.lastId = data.content.last?.reviewId
          self.reviewState.canLoadNextPage = data.hasNext
          
          self.myReview = self.reviewState.content.filter { $0.writer.userID == MyData.userID }.first
        }
      }
      .store(in: &subscription)
  }
  
  // MARK: Create
  /// 리뷰 생성
  func createReview(placeId: String, rating: Double, review: String) {
    isProgressing = true
    let rating = Int(rating * 2)
    
    reviewProvider.requestPublisher(.createReview(placeId: placeId, rating: rating, review: review))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("한줄리뷰 생성 완료")
          self.isPosted.toggle()
          self.needToRefresh.toggle()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
        self.isProgressing = false
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: Update
  /// 리뷰 수정
  func updateReview(reviewId: Int, rating: Double, review: String) {
    isProgressing = true
    let rating = Int(rating * 2)
    
    reviewProvider.requestPublisher(.updateReview(id: reviewId, rating: rating, review: review))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("한줄리뷰 수정 완료")
          self.isPosted.toggle()
          self.needToRefresh.toggle()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
        self.isProgressing = false
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: Delete
  /// 리뷰 삭제
  func deleteReview(reviewId: Int) {
    isProgressing = true
    
    reviewProvider.requestPublisher(.deleteReview(reviewId: reviewId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("한줄리뷰 삭제 완료")
          self.needToRefresh.toggle()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
        self.isProgressing = false
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
}
