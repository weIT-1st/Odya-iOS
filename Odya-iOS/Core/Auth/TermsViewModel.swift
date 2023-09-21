//
//  TermsViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/14.
//

import Combine
import CombineMoya
import Foundation
import Moya

final class TermsViewModel: ObservableObject {
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var termsProvider = MoyaProvider<TermsRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()

  @Published var termsList: TermsList = []
  @Published var requiredList: [Int] = []
  @Published var termsContent: String = ""

  /// 약관리스트 조회
  func getTermsList() {
    termsProvider.requestPublisher(.getTermsList)
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("DEBUG: 약관 리스트 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(TermsList.self) {
          self.termsList = data
          self.requiredList = self.termsList.filter { $0.isRequired == true }.map { $0.id }
        }
      }
      .store(in: &subscription)
  }

  /// 약관내용 조회
  func getTermsContent(id: Int) {
    termsProvider.requestPublisher(.getTermsContent(termsId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("DEBUG: 약관 내용 조회 완료")
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        if let data = try? response.map(TermsContent.self) {
          self.termsContent = data.content
        }
      }
      .store(in: &subscription)
  }
}
