//
//  HomeViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/26.
//

import Combine
import GooglePlaces
import Moya
import SwiftUI

final class HomeViewModel: ObservableObject {
  // MARK: Properties
  
  @AppStorage("WeITAuthToken") var idToken: String?
  // plugins
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  // providers
  private lazy var imageProvider = MoyaProvider<CoordinateImageRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  var subscription = Set<AnyCancellable>()

  @Published var images = [CoordinateImage]()
  
  // MARK: Helper functions
  
  func fetchCoordinateImages(leftLong: Double, bottomLat: Double, rightLong: Double, topLat: Double) {
    subscription.forEach { $0.cancel() }
    
    imageProvider.requestPublisher(.getCoordinateImages(leftLongitude: leftLong, bottomLatitude: bottomLat, rightLongitude: rightLong, topLatitude: topLat, size: nil))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("좌표 이미지 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map([CoordinateImage].self) {
          self.images = data
        }
      }
      .store(in: &subscription)
  }
  
  func handleErrorData(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("\(errorData.code): \(errorData.message)")
    } else {
      print("알 수 없는 오류 발생")
    }
  }
}
