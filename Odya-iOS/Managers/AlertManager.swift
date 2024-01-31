//
//  AlertManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/06.
//

import SwiftUI
import Moya
import Combine
import CombineMoya

class AlertManager: ObservableObject {
//    @Published var showAlertOfTravelJournalCreation: Bool = false
//    @Published var showFailureAlertOfTravelJournalCreation: Bool = false
  
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  var isUpdating: Bool = false
  
  func updateFCMToken(newToken: String) {
    if isUpdating {
      return
    }
    
    userProvider.requestPublisher(.updateFCMToken(newToken: newToken))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isUpdating = false
        case .failure(let error):
          self.processErrorResponse(error)
          self.isUpdating = false
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
    
  // MARK: error handling
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("ERROR: In FCM token updating with \(errorData.message)")
    } else {  // unknown error
      print("ERROR: \(error.localizedDescription)")
    }
  }
}
