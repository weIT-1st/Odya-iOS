//
//  ProfileViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Combine
import CombineMoya
import Foundation
import Moya
import SwiftUI

class ProfileViewModel: ObservableObject {
  // token
  @Published var appDataManager = AppDataManager()
  @AppStorage("WeITAuthToken") var idToken: String?

  // Moya
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()

  // user data
  @Published var userID: Int = -1
  @Published var nickname: String = ""
  @Published var profileUrl: String = ""
  @Published var statistics = UserStatistics()
  @Published var potdList: [UserImage] = []

  //  flag
  var isFetchingStatistics: Bool = false
  var isUpdatingProfileImg: Bool = false
  var isFetchingPOTDList: Bool = false

  /// POTD 무한스크롤
  var fetchMorePOTDSubject = PassthroughSubject<(), Never>()
  /// 더 가져올 유저의 인생샷이 있는지 여부
  var hasNextPOTD: Bool = true
  /// 마지막으로 가져온 유저의 인생샷 아이디
  var lastIdOfPOTD: Int? = nil

  // profileImage
  var webpImageManager = WebPImageManager()

  // MARK: Init

  init() {
    let myData = MyData()
    self.userID = MyData.userID
    self.nickname = myData.nickname
    self.profileUrl = myData.profile.decodeToProileData().profileUrl

    initFetchMorePOTDSubject()
  }

  func initData(_ userId: Int, _ nickname: String, _ profileUrl: String) {
    self.userID = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
  }

  // MARK: Fetch Data
  func fetchDataAsync() async {
    guard let idToken = idToken else {
      return
    }

    getUserStatistics(idToken: idToken)
    initPOTDList()
  }

  // MARK: User Statistics
  func updateUserStatistics() {
    guard let idToken = idToken else {
      return
    }
    getUserStatistics(idToken: idToken)
  }

  private func getUserStatistics(idToken: String) {
    if isFetchingStatistics {
      return
    }

    isFetchingStatistics = true

    userProvider.requestPublisher(.getUserStatistics(userId: self.userID))
      .sink { completion in
        switch completion {
        case .finished:
          self.isFetchingStatistics = false
        case .failure(let error):
          self.isFetchingStatistics = false
          self.processErrorResponse(error: error)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserStatistics.self)
          self.statistics = responseData
        } catch {
          return
        }
      }.store(in: &subscription)
  }

  // MARK: Profile Image
  func updateProfileImage(newProfileImg: [ImageData]) async {
    if isUpdatingProfileImg {
      return
    }

    isUpdatingProfileImg = true

    var newImage: (data: Data, name: String)? = nil
    if !newProfileImg.isEmpty {
      newImage = await webpImageManager.processImages(images: newProfileImg).first
    }

    userProvider.requestPublisher(.updateUserProfileImage(profileImg: newImage))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isUpdatingProfileImg = false
          self.appDataManager.initMyData { success in
            if success {
              let myData = MyData()
              self.profileUrl = myData.profile.decodeToProileData().profileUrl
            }
          }
        case .failure(let error):
          self.isUpdatingProfileImg = false
          self.processErrorResponse(error: error)
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)
  }

  // MARK: POTD

  private func initFetchMorePOTDSubject() {
    fetchMorePOTDSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isFetchingPOTDList && self.hasNextPOTD {
        fetchPOTDList()
      }
    }.store(in: &subscription)
  }

  private func initPOTDList() {
    hasNextPOTD = true
    lastIdOfPOTD = nil
    DispatchQueue.main.async {
      self.potdList = []
    }

    fetchPOTDList()
  }

  private func fetchPOTDList(size: Int = 10) {
    if isFetchingPOTDList {
      return
    }

    isFetchingPOTDList = true
    userProvider.requestPublisher(.getPOTDList(userId: userID, size: size, lastId: lastIdOfPOTD))
      .sink { apiCompletion in
        self.isFetchingPOTDList = false
        switch apiCompletion {
        case .finished:
          print("fetch user images")
        case .failure(let error):
          self.processErrorResponse(error: error)
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(UserImagesResponse.self)

          self.potdList += responseData.content
          self.hasNextPOTD = responseData.hasNext
          self.lastIdOfPOTD = responseData.content.last?.imageId ?? nil

        } catch {
          print("user Images response decoding error")
          return
        }
      }.store(in: &subscription)
  }

  // MARK: Error Handling

  private func processErrorResponse(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("in profile view model - \(errorData.message)")
    } else {  // unknown error
      print("in profile view model - \(error)")
    }
  }
}
