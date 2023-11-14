//
//  FeedDetailViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/30.
//

import Combine
import Moya
import SwiftUI

final class FeedDetailViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: [.successResponseBody, .errorResponseBody]))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 피드 디테일
  @Published var feedDetail: FeedDetail!
  
  /// Alert
  @Published var showAlert: Bool = false
  @Published var alertTitle = ""
  @Published var alertMessage = ""
  
  // MARK: - Read
  /// 게시글 상세조회
  func fetchFeedDetail(id: Int) {
    communityProvider.requestPublisher(.getCommunityDetail(communityId: id))
      .sink { completion in
        switch completion {
        case .finished:
          print("피드 디테일 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            self.alertTitle = "게시글 내용 조회 에러"
            self.alertMessage = errorData.message
            self.showAlert = true
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(FeedDetail.self) {
          self.feedDetail = data
        }
      }
      .store(in: &subscription)
  }
  
  // MARK: - Delete
  /// 게시글 삭제
  func deleteCommunity(id: Int) {
    communityProvider.requestPublisher(.deleteCommunity(communityId: id))
      .sink { completion in
        switch completion {
        case .finished:
          print("피드 삭제 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            self.alertTitle = "게시글 삭제 에러"
            self.alertMessage = errorData.message
            self.showAlert = true
          }
        }
      } receiveValue: { response in
        if response.statusCode >= 200 && response.statusCode < 300 {
          self.alertTitle = "게시글 삭제 성공"
          self.alertMessage = "이전 화면으로 돌아갑니다"
          self.showAlert = true
        }
      }
      .store(in: &subscription)
  }
}
