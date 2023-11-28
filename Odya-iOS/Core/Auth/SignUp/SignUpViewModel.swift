//
//  SignUpViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/27.
//

import Combine
import Moya
import SwiftUI

class SignUpViewModel: ObservableObject {
  /// Provider
//  @AppStorage("WeITAuthToken") var idToken: String?
//  private let logPlugin: PluginType = NetworkLoggerPlugin(
//    configuration: .init(logOptions: [.successResponseBody, .errorResponseBody]))
//  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
//  private lazy var topicProvider = MoyaProvider<TopicRouter>(
//    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
//  private var subscription = Set<AnyCancellable>()
  
  /// sign up step
  @Published var step: Int = -1
  
  /// sign up data
  @Published var nickname: String = ""
  @Published var birthday: Date = Date()
  @Published var gender: Gender = .none
  @Published var favoriteTopics: [Topic] = []
  @Published var termsIdList: [Int] = []
  
  var topicListVM = TopicListViewModel()
  
//  var topicList: [Topic] = []
//  func fetchTopicList() {
//    topicProvider.requestPublisher(.getTopicList)
//      .sink { completion in
//        switch completion {
//        case .finished:
//          print("토픽 리스트 조회")
//        case .failure(let error):
//          if let errorData = try? error.response?.map(ErrorData.self) {
//            print(errorData.message)
//          }
//        }
//      } receiveValue: { response in
//        if let data = try? response.map(TopicList.self) {
//          self.topicList = data
//        }
//      }
//      .store(in: &subscription)
//  }
}
