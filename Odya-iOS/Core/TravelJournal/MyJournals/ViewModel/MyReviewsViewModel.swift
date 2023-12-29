//
//  MyReviewsViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/26.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

class MyReviewsViewModel: ObservableObject {
  // moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var reviewProvider = MoyaProvider<ReviewRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  @Published var reviews: [Review] = []
  
  // loading flag
  @Published var isMyReviewsLoading: Bool = false
  var isDeleting: Bool = false

  // infinite Scroll
  @Published var lastId: Int? = nil
  var hasNext: Bool = true
  var fetchMoreReviewSubject = PassthroughSubject<(), Never>()

  init() {
    fetchDataAsync()

    fetchMoreReviewSubject
      .sink { [weak self] _ in
        guard let self = self,
          !self.isMyReviewsLoading,
          self.hasNext
        else {
          return
        }
        self.getMyReviews()
      }.store(in: &subscription)
  }

  func fetchDataAsync() {
    if isMyReviewsLoading
      || !hasNext
    {
      return
    }

    getMyReviews()
  }

  func updateMyReviews() {
    isMyReviewsLoading = false
    hasNext = true
    lastId = nil
    reviews = []

    getMyReviews()
  }

  private func getMyReviews() {
    self.isMyReviewsLoading = true
    reviewProvider.requestPublisher(.readUserIdReview(userId: MyData.userID, size: nil, sortType: nil, lastId: self.lastId))
    .sink { completion in
      switch completion {
      case .finished:
        self.isMyReviewsLoading = false
      case .failure(let error):
        self.isMyReviewsLoading = false
        self.processErrorResponse(error)
      }
    } receiveValue: { response in
      do {
        let responseData = try response.map(ReviewListResponse.self)
        self.hasNext = responseData.hasNext
        self.reviews += responseData.content
        self.lastId = responseData.content.last?.reviewId
      } catch {
        return
      }
    }.store(in: &subscription)
  }

  // MARK: Delete Tag
  func deleteMyReview(of reviewId: Int, completion: @escaping (Bool) -> Void) {
    if isDeleting {
      return
    }

    isDeleting = true
    reviewProvider.requestPublisher(.deleteReview(reviewId: reviewId))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isDeleting = false
          completion(true)
        case .failure(let error):
          self.isDeleting = false
          self.processErrorResponse(error)
          completion(false)
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in my reviews view model - \(errorData.message)")
    } else {  // unknown error
      print("in my reviews view model - \(error)")
    }
  }
}
