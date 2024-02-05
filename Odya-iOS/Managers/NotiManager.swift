//
//  NotiManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/06.
//

import SwiftUI
import Moya
import Combine
import CombineMoya

class NotiManager: ObservableObject {
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  var isUpdating: Bool = false
  
  func sendLocalNoti(notiMsg: String) {
    let notiContent = UNMutableNotificationContent()
    notiContent.title = NSString.localizedUserNotificationString(forKey: "ODYA", arguments: nil)
    notiContent.body = NSString.localizedUserNotificationString(forKey: notiMsg, arguments: nil)
    notiContent.sound = UNNotificationSound.default
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: nil)
    let center = UNUserNotificationCenter.current()
    center.add(request) { (error : Error?) in
      if let theError = error {
        // Handle any errors
        print(theError)
      }
    }
  }
  
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
