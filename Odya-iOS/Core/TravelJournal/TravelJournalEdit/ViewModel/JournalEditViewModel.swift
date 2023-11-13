//
//  JournalEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/22.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

class JournalEditViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  var appDataManager = AppDataManager()
  var webPImageManager = WebPImageManager()

  // user id token
  @AppStorage("WeITAuthToken") var idToken: String?

  // journal info
  let journalId: Int
  let startDate: Date
  let endDate: Date
  let originalJournal: DailyJournal

  // daily journal data
  @Published var date: Date
  @Published var content: String
  @Published var placeId: String?
  @Published var latitudes: [Double] = []
  @Published var longitudes: [Double] = []
  @Published var fetchedImages: [DailyJournalImage] = []
  @Published var selectedImages: [ImageData] = []

  /// 수정 중인 데일리 일정 아이디 리스트
  /// 해당 데일리 일정 중복 수정을 방지하는 데에 사용됨
  var updatingDailyJournalsId: [Int] = []

  // MARK: Init

  init(journal: TravelJournalDetailData, dailyJournal: DailyJournal) {
    self.journalId = journal.journalId
    self.startDate = journal.travelStartDate
    self.endDate = journal.travelEndDate
    self.originalJournal = dailyJournal

    self.date = dailyJournal.travelDate
    self.content = dailyJournal.content
    self.placeId = dailyJournal.placeId
    self.latitudes = dailyJournal.latitudes
    self.longitudes = dailyJournal.longitudes
    self.fetchedImages = dailyJournal.images
  }

  // MARK: update daily journal

  /// 데일리 일정 업데이트 api 호출
  func updateDailyJournalAPI(idToken: String, webpImages: [(data: Data, name: String)]) async throws
    -> Bool
  {
    var deletedImagesId: [Int] =
      fetchedImages
      .filter { !originalJournal.images.contains($0) }
      .map { $0.imageId }

    return try await withCheckedThrowingContinuation { continuation in
      journalProvider.request(
        .editContent(
          token: idToken,
          journalId: self.journalId,
          contentId: self.originalJournal.dailyJournalId,
          content: self.content,
          placeId: self.placeId,
          latitudes: self.latitudes,
          longitudes: self.longitudes,
          date: self.date.toIntArray(),
          newImageNames: webpImages.map { $0.name },
          deletedImageIds: deletedImagesId,
          newImageTotalCount: webpImages.count,
          images: webpImages)
      ) { result in
        switch result {
        case let .success(response):
          // 성공적으로 API 호출된 경우
          do {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: response.data)
            continuation.resume(throwing: MyError.apiError(errorData))
          } catch {
            print("여행일지 수정 성공")
            continuation.resume(returning: true)  // 여행일지 수정 성공
          }

        case let .failure(error):
          // API 호출 실패 시 에러 처리
          continuation.resume(throwing: MyError.unknown(error.localizedDescription))
        }
      }
    }
  }

  /// 데일리 일정 업데이트해주는 함수
  /// 새로 선택된 사진을 리사이징,  webp 변환한 후 api 호출
  func updateDailyJournal() async {
    guard let idToken = self.idToken else {
      return
    }

    if updatingDailyJournalsId.contains(where: { $0 == journalId }) {
      return
    }

    updatingDailyJournalsId.append(journalId)

    do {
      // webp 변환하기
      let webPImages = await webPImageManager.processImages(images: selectedImages)

      // api 호출
      _ = try await updateDailyJournalAPI(idToken: idToken, webpImages: webPImages)

      self.updatingDailyJournalsId = self.updatingDailyJournalsId.filter { $0 != journalId }
      // print("여행일지 수정 성공")
    } catch {
      self.updatingDailyJournalsId = self.updatingDailyJournalsId.filter { $0 != journalId }
      if let myError = error as? MyError {
        switch myError {
        case .apiError(let errorData):
          print("API Error Code: \(errorData.code), Message: \(errorData.message)")
        case .unknown(let message):
          print("Unknown error: \(message)")

        default:
          print("Error: something error during Updating journal")
        }
      } else {
        print("An unexpected error occurred: \(error)")
      }
    }
  }

}
