//
//  FollowButtonViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/17.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

/// 팔로우 버튼에서 팔로우/언팔로우만 실행하기 위한 뷰모델
class FollowButtonViewModel: ObservableObject {
  // MARK: Properties
  
  /// provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var followProvider = MoyaProvider<FollowRouter>(plugins: [logPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // MARK: Follow / Unfollow
  
  /// 팔로우 실행
  func createFollow(_ followingID: Int) {
    followProvider.requestPublisher(.create(followingID: followingID))
      .sink { completion in
        switch completion {
        case .finished:
          print("create new follow \(followingID)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }
  
  /// 언팔로우 실행
  func deleteFollow(_ followingID: Int) {
    followProvider.requestPublisher(.delete(followingID: followingID))
      .sink { completion in
        switch completion {
        case .finished:
          print("delete follow \(followingID)")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }
}
