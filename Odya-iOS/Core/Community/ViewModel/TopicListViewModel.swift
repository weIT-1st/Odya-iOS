//
//  TopicListViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/31.
//

import Combine
import Moya
import SwiftUI

final class TopicListViewModel: ObservableObject {
  // MARK: Properties
  
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var topicProvider = MoyaProvider<TopicRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 토픽 리스트 저장
  @Published var topicList: [Topic] = []
  
  /// 관심토픽 리스트
  @Published var myTopicList: [Topic] = []
  
  @Published var ProcessingMyTopicsCount: Int = 0
  
  // MARK: - Read
  /// 토픽 리스트 조회
  func fetchTopicList() {
    topicProvider.requestPublisher(.getTopicList)
      .sink { completion in
        switch completion {
        case .finished:
          print("토픽 리스트 조회")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(TopicList.self) {
          self.topicList = data
        }
      }
      .store(in: &subscription)
  }
  
  func fetchMyTopicList(completion: @escaping (Bool) -> Void) {
    topicProvider.requestPublisher(.getMyTopicList)
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          print("관심 토픽 리스트 조회")
          completion(true)
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
          completion(false)
        }
      } receiveValue: { response in
        if let data = try? response.map(TopicList.self) {
          self.myTopicList = data
        }
      }
      .store(in: &subscription)
  }
  
  // MARK: Add
  /// 관심 토픽 등록
  func addMyTopics(idList: [Int]) {
    ProcessingMyTopicsCount += 1
    topicProvider.requestPublisher(.createMyTopic(idList: idList))
      .sink { completion in
        self.ProcessingMyTopicsCount -= 1
        switch completion {
        case .finished:
          print("토픽 추가 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }
  
  // MARK: Delete
  /// 관심 토픽 해제
  func deleteMyTopic(id: Int) {
    ProcessingMyTopicsCount += 1
    topicProvider.requestPublisher(.deleteMyTopic(id: id))
      .sink { completion in
        self.ProcessingMyTopicsCount -= 1
        switch completion {
        case .finished:
          print("토픽 삭제 완료")
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
