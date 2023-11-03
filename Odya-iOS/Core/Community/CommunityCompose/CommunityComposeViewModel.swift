//
//  CommunityComposeViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/31.
//

import Combine
import Moya
import SwiftUI

final class CommunityComposeViewModel: ObservableObject {
  // MARK: Properties
  /// Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 이미지 webp 변환
  let webpConverter = WebpViewModel()
  
  /// 작성완료 여부
  @Published var isSubmitted: Bool = false
  
  // MARK: Create
  func createCommunity(content: String, visibility: String = "PUBLIC", placeId: String?, travelJournalId: Int?, topicId: Int?, imageData: [ImageData]) {
    let uiImageList = imageData.map { $0.image }
    _Concurrency.Task {
      let _ = await webpConverter.processImages(uiImages: uiImageList)
      let webpImageList = webpConverter.webpImages
      var finalImageList = [(data: Data, name: String)]()
      for index in 0..<webpImageList.count {
        finalImageList.append((data: webpImageList[index], name: imageData[index].imageName))
      }
      
      communityProvider.requestPublisher(.createCommunity(content: content,
                                                          visibility: visibility,
                                                          placeId: placeId,
                                                          travelJournalId: travelJournalId,
                                                          topicId: topicId,
                                                          images: finalImageList)
      )
      .sink { completion in
        switch completion {
        case .finished:
          print("커뮤니티 생성 완료")
          self.isSubmitted = true
        case .failure(let error):
          if let errorData = try? error.response?.map(ErrorData.self) {
            print(errorData.message)
          }
        }
      } receiveValue: { response in
        print(response)
      }
      .store(in: &subscription)
    }
  }
  
  // MARK: Update
}
