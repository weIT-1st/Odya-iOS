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
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 이미지 webp 변환
  let webpConverter = WebPImageManager()
  
  /// 작성완료 여부
  @Published var isSubmitted: Bool = false
  
  // MARK: Create
  /// 커뮤니티 생성
  func createCommunity(content: String, visibility: String, placeId: String?, travelJournalId: Int?, topicId: Int?, imageData: [ImageData]) {
    _Concurrency.Task {
      let _ = await webpConverter.processImages(images: imageData)
      let webpImageList = webpConverter.webpImages
      
      communityProvider.requestPublisher(.createCommunity(content: content,
                                                          visibility: visibility,
                                                          placeId: placeId,
                                                          travelJournalId: travelJournalId,
                                                          topicId: topicId,
                                                          images: webpImageList)
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
  /// 커뮤니티 수정
  func updateCommunity(communityId: Int, content: String, visibility: String, placeId: String?, travelJournalId: Int?, topicId: Int?, deleteImageIds: [Int]?, updateImageData: [ImageData]) {
    _Concurrency.Task {
      let _ = await webpConverter.processImages(images: updateImageData)
      let webpImageList = webpConverter.webpImages
      
      communityProvider.requestPublisher(.updateCommunity(communityId: communityId, content: content, visibility: visibility, placeId: placeId, travelJournalId: travelJournalId, topicId: topicId, deleteImageIds: deleteImageIds, updateImages: webpImageList))
        .sink { completion in
          switch completion {
          case .finished:
            print("커뮤니티 수정 완료")
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
}
