//
//  PlaceDetailViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/08.
//

import Combine
import GooglePlaces
import Moya
import SwiftUI

final class PlaceDetailViewModel: ObservableObject {
  // MARK: - Properties
  @AppStorage("WeITAuthToken") var idToken: String?
  // plugins
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  // providers
  private lazy var followProvider = MoyaProvider<FollowRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private lazy var communityProvider = MoyaProvider<CommunityRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private lazy var reviewProvider = MoyaProvider<ReviewRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // google places
  private let placeClient = GMSPlacesClient()
  
  // data for view
  @Published var placeImage: UIImage?
  @Published var visitorCount: Int? = nil
  @Published var visitorList = [FollowUserData]()
  
  struct FeedState {
    var content: [MyCommunityContent] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var feedState = FeedState()
  
  struct ReviewState {
    var content: [Review] = []
    var lastId: Int? = nil
    var canLoadNextPage = true
  }
  
  @Published private(set) var reviewState = ReviewState()
  
  @Published var isReviewExisted: Bool? = nil
  @Published var reviewCount: Int? = nil
  @Published var averageStarRating: Double = 0.0
  
  @Published var myReview: Review? = nil
  
  // MARK: - Helper functions
  
  /// 장소 사진 가져오기
  func fetchPlaceImage(placeId: String, token: GMSAutocompleteSessionToken?) {
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
    placeClient.fetchPlace(fromPlaceID: placeId,
                           placeFields: fields,
                           sessionToken: token) { place, error in
      if let error = error {
        print("An error occurred: \(error.localizedDescription)")
        return
      }
      if let place {
        let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
        self.placeClient.loadPlacePhoto(photoMetadata) { photo, error in
          if let error {
            print("Error loading photo metadata: \(error.localizedDescription)")
                    return
          } else {
            self.placeImage = photo
          }
        }
      }
    }
  }
  
  /// 방문한 친구수 조회
  func fetchVisitingUser(placeId: String) {
    if placeId.isEmpty { return }
    
    followProvider.requestPublisher(.getVisitingUser(placeId: placeId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("장소 상세보기 - 방문한 친구 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(VisitorResponse.self) {
          self.visitorCount = data.count
          self.visitorList = data.visitors
        }
      }
      .store(in: &subscription)
  }
  
  /// 한줄리뷰 관련 조회
  func fetchReviewInfo(placeId: String) {
    fetchIfReviewExist(placeId: placeId)
    fetchReviewCount(placeId: placeId)
    fetchAverageStarRating(placeId: placeId)
  }
  
  /// 한줄리뷰 작성 여부 조회
  private func fetchIfReviewExist(placeId id: String) {
    reviewProvider.requestPublisher(.getIfReviewExist(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("리뷰 작성 여부 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewExistResponse.self) {
          self.isReviewExisted = data.exist
        }
      }
      .store(in: &subscription)
  }
  
  /// 한줄리뷰 개수 조회
  private func fetchReviewCount(placeId id: String) {
    reviewProvider.requestPublisher(.getReviewCount(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("리뷰 수 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewCountResponse.self) {
          self.reviewCount = data.count
        }
      }
      .store(in: &subscription)
  }
  
  /// 리뷰 평균 별점 조회
  private func fetchAverageStarRating(placeId id: String) {
    reviewProvider.requestPublisher(.getAverageStarRating(placeId: id))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("평균 별점 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewAverageStarRatingResponse.self) {
          self.averageStarRating = data.averageStarRating / 2
        }
      }
      .store(in: &subscription)
  }
  
  func fetchReviewByPlaceNextPageIfPossible(placeId: String) {
    guard reviewState.canLoadNextPage else { return }
    if placeId.isEmpty { return }
    
    reviewProvider.requestPublisher(.readPlaceIdReview(placeId: placeId, size: nil, sortType: nil, lastId: reviewState.lastId))
      .sink { completion in
        switch completion {
        case .finished:
          debugPrint("장소 리뷰 조회 완료")
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(ReviewListResponse.self) {
          self.reviewState.content = data.content
          self.reviewState.lastId = data.content.last?.reviewId
          self.reviewState.canLoadNextPage = data.hasNext
          
          self.myReview = self.reviewState.content.filter { $0.writer.userID == MyData.userID }.first
        }
      }
      .store(in: &subscription)
  }
  
  /// 장소 Id로 커뮤니티 조회
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
  
  /// 에러 핸들링
  func handleErrorData(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("\(errorData.code): \(errorData.message)")
    } else {
      print("알 수 없는 오류 발생")
    }
  }
}
