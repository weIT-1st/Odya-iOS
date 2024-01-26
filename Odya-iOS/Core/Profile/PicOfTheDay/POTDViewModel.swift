//
//  POTDViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/07.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

class POTDViewModel: ObservableObject {
  @AppStorage("WeITAuthToken") var idToken: String?

  // moya
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var imageProvider = MoyaProvider<ImageRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  /// 인생샷을 추가, 삭제 중일 때 켜지는 플래그
  var isProcessing: Bool = false
  /// 유저의 이미지를 가져오는 중일 때 켜지는 플래그
  var isFetching: Bool = false

  /// 무한스크롤
  var fetchMoreSubject = PassthroughSubject<(), Never>()

  /// 더 가져올 유저의 사진이 있는지 여부
  var hasNextImages: Bool = true
  /// 마지막으로 가져온 유저의 이미지 아이디
  var lastIdOfImages: Int? = nil

  /// 유저가 피드 및 여행일지에 올린 이미지 리스트
  @Published var userImageList: [UserImage] = []
  /// 인생샷 등록을 위해 선택한 이미지
  @Published var selectedImage: UserImage? = nil

  // MARK: Init

  init() {
    fetchImages()

    fetchMoreSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isFetching && self.hasNextImages {
        fetchImages()
      }
    }.store(in: &subscription)
  }

  // MARK: Fetch

  private func fetchImages(size: Int = 30) {
    if isFetching {
      return
    }

    isFetching = true
    imageProvider.requestPublisher(.getImages(size: size, lastId: lastIdOfImages))
      .sink { apiCompletion in
        self.isFetching = false
        switch apiCompletion {
        case .finished:
          print("fetch user images")
        case .failure(let error):
          self.processErrorResponse(error: error)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserImagesResponse.self)

          self.userImageList += responseData.content
          self.hasNextImages = responseData.hasNext
          self.lastIdOfImages = responseData.content.last?.imageId ?? nil

        } catch {
          print("user Images response decoding error")
          return
        }
      }.store(in: &subscription)
  }

  // MARK: Register

  func registerPOTD(imageId: Int, placeName: String?) {
    if isProcessing {
      return
    }

    isProcessing = true
    imageProvider.requestPublisher(.registerPOTD(imageId: imageId, placeName: placeName))
      .sink { apiCompletion in
        self.isProcessing = false
        switch apiCompletion {
        case .finished:
          print("register new POTD")
          if let (index, _) = self.userImageList.enumerated().first(where: {
            $0.element.imageId == imageId
          }) {
            self.userImageList[index].isLifeShot = true
          }
        case .failure(let error):
          self.processErrorResponse(error: error)
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  // MARK: Delete

  func deletePOTD(
    imageId: Int,
    completion: @escaping () -> Void
  ) {
    if isProcessing {
      return
    }

    isProcessing = true
    imageProvider.requestPublisher(.deletePOTD(imageId: imageId))
      .sink { apiCompletion in
        self.isProcessing = false
        switch apiCompletion {
        case .finished:
          print("delete POTD \(imageId)")
          completion()
        case .failure(let error):
          self.processErrorResponse(error: error)
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  // MARK: Error Handling
  private func processErrorResponse(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print(errorData.message)
    } else {  // unknown error
      print(error)
    }
  }
}
