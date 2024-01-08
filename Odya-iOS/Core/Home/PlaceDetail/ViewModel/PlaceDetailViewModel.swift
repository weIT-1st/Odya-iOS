//
//  PlaceDetailViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/08.
//

import Combine
import Moya
import SwiftUI

final class PlaceDetailViewModel: ObservableObject {
  /// API Provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  struct FeedState {
    var content: [MyCommunityContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var feedState = FeedState()
  
  /// 내 커뮤니티 활동 - 좋아요한 게시글 불러오기
  func fetchAllFeedByPlaceNextPageIfPossible(placeId: String) {
    guard feedState.canLoadNextPage else { return }
    if placeId.isEmpty { return }
    
    communityProvider.requestPublisher(.getAllCommunity(size: nil, lastId: feedState.lastId, sortType: nil, placeId: placeId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("장소 상세보기 - 커뮤니티 조회 완료. 다음 페이지 \(self.feedState.canLoadNextPage)")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(MyCommunity.self) {
          self.feedState.content += data.content
          self.feedState.lastId = data.content.last?.communityID
          self.feedState.canLoadNextPage = data.hasNext
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
