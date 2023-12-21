//
//  MyReviewListViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/17.
//

import SwiftUI
import Moya
import CombineMoya
import Combine

class MyReviewListViewModel: ObservableObject {
  // Moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var reviewProvider = MoyaProvider<ReviewRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  func getMyReviews() {
    reviewProvider.requestPublisher(.readUserIdReview(userId: MyData.userID, size: nil, sortType: nil, lastId: nil))
  }
}
