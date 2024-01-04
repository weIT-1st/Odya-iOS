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
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var followProvider = MoyaProvider<FollowRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
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
  
  // MARK: is My Following User
  
  /// 팔로우 버튼 초기값 설정을 위해 팔로잉 여부를 확인
  func isMyFollowingUser(_ userId: Int, completion: @escaping (Bool) -> Void) {
    fetchAllFollowingUsers() { allUsers in
      let ret = allUsers.contains(where: {$0.userId == userId})
      completion(ret)
    }
  }
  
  private func fetchAllFollowingUsers(completion: @escaping ([FollowUserData]) -> Void) {
    var page: Int = 0
    var hasNext: Bool = true
    var allFollowingUsers: [FollowUserData] = []

    func fetchFollowingUsers(completion: @escaping (Bool) -> Void) {
      if !hasNext {
        return
      }
      
      followProvider.requestPublisher(.getFollowing(userID: MyData.userID, page: page, size: 100, sortType: .latest))
        .sink { apiCompletion in
          switch apiCompletion {
          case .finished:
            page += 1
            completion(true)
          case .failure(let error):
            if let errorData = try? error.response?.map(ErrorData.self) {
              print(errorData.message)
            } else {
              print(error)
            }
            completion(false)
          }
        } receiveValue: { response in
          do {
            let responseData = try response.map(FollowUserListResponse.self)
            hasNext = responseData.hasNext
            allFollowingUsers += responseData.content
          } catch {
            return
          }
        }.store(in: &subscription)
    } // fetchFollowingUsers()
    
    func fetchNextPage() {
      fetchFollowingUsers() { success in
        if success {
          if hasNext {
            fetchNextPage()
          } else {
            print("get all following users")
            completion(allFollowingUsers)
          }
        } else {
          completion([])
        }
      }
    } // fetchNextPage()
    
    fetchNextPage()
  }
  
  
}
