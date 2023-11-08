//
//  TravelJournalEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/22.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

enum PrivacyType {
  case global
  case friendsOnly
  case personal

  func toString() -> String {
    switch self {
    case .global:
      return "PUBLIC"
    case .friendsOnly:
      return "FRIEND_ONLY"
    case .personal:
      return "PRIVATE"
    }
  }
}

class TravelJournalEditViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()

  var webPImageManager = WebPImageManager()

  @AppStorage("WeITAuthToken") var idToken: String?

  var isJournalCreating: Bool = false

  // travel journal data
  @Published var title: String = ""
  @Published var startDate = Date()
  @Published var endDate = Date()
  @Published var travelMates: [FollowUserData] = []
  @Published var dailyJournalList: [DailyTravelJournal] = []
  @Published var privacyType: PrivacyType = .global
  @Published var pickedJournalIndex: Int? = nil

  var duration: Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    if let day = components.day {
      return day + 1
    }
    return 0
  }

  // MARK: Functions - travel dates

  func setTravelDates(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }

  func setJournalDate(selectedDate: Date) {
    if let idx = self.pickedJournalIndex {
      self.dailyJournalList[idx].date = selectedDate
    }
  }

  // MARK: Functions - register

  func validateTravelJournal() -> Bool {
    // 제목이 20자가 넘는 경우
    if title.count > 20 {
      return false
    }
    // 여행 일지 콘텐츠가 15개 초과인 경우
    if dailyJournalList.count > 15 {
      return false
    }

    // 여행 일지 콘텐츠의 이미지 제목이 비어있는 경우
    if dailyJournalList.contains(where: { dailyJournal in
      dailyJournal.selectedImages.contains { $0.imageName == "" }
    }) {
      return false
    }
    // 여행 일지 콘텐츠의 이미지 제목 개수가 15개를 초과하는 경우
    if dailyJournalList.contains(where: { $0.selectedImages.count > 15 }) {
      return false
    }
    // 여행 이미지가 비어있는 경우

    // 여행 일지 콘텐츠의 이미지 이름 개수와 실제 이미지 개수가 다를 경우

    // 여행 이미지가 225개를 초과하는 경우
    if dailyJournalList.map({ $0.selectedImages.count }).reduce(0, +) > 225 {
      return false
    }

    // 여행 일지의 시작일이 여행 일지의 종료일보다 늦을 경우
    if startDate > endDate {
      return false
    }
    // 여행 일자보다 콘텐츠의 개수가 많을 경우
    if duration < dailyJournalList.count {
      return false
    }
    // 여행 콘텐츠 일자가 여행 시작일보다 이전이거나 여행 종료일보다 이후일 경우
    if dailyJournalList.contains(where: {
      guard let date = $0.date else { return true }
      if date < startDate || date > endDate { return true }
      return false
    }) {
      return false
    }
    // 여행 일자가 15일 초과인 경우
    if duration > 15 {
      return false
    }

    // 여행 친구 아이디가 등록되지 않은 사용자인 경우

    // 여행 친구가 10명 초과인 경우
    if travelMates.count > 10 {
      return false
    }

    // 여행 일지 콘텐츠의 이름이 실제 이미지 파일 이름과 일치하지 않는 경우

    // 위도와 경도 중에 하나만 null인 경우
    // 위도와 경도의 개수가 다를 경우
    // 유효하지 않은 장소 id인 경우
    return true
  }

  func createJournalAPI(idToken: String, webpImages: [(data: Data, name: String)]) async throws
    -> Bool
  {
    // API 호출
    return try await withCheckedThrowingContinuation { continuation in
      journalProvider.request(
        .create(
          token: idToken, title: title, startDate: startDate.toIntArray(),
          endDate: endDate.toIntArray(), visibility: privacyType.toString(),
          travelMateIds: travelMates.map { $0.userId }, travelMateNames: [],
          dailyJournals: dailyJournalList, travelDuration: duration,
          imagesTotalCount: webpImages.count, images: webpImages)
      ) { result in
        switch result {
        case let .success(response):
          // 성공적으로 API 호출된 경우
          do {
            let errorData = try JSONDecoder().decode(ErrorData.self, from: response.data)
            continuation.resume(throwing: MyError.apiError(errorData))
          } catch {
            print("여행일지 작성 성공")
            continuation.resume(returning: true)  // 여행일지 작성 성공
          }

        case let .failure(error):
          // API 호출 실패 시 에러 처리
          continuation.resume(throwing: MyError.unknown(error.localizedDescription))
        }
      }
    }
  }

  func registerTravelJournal() async {
    print("여행일지 등록하기 버튼 클릭")
    guard let idToken = idToken else {
      return
    }

    self.isJournalCreating = true

    do {
      // webp 변환하기
      let images = dailyJournalList.flatMap { $0.selectedImages }
      let webPImages = await webPImageManager.processImages(images: images)

      // api 호출
      _ = try await createJournalAPI(idToken: idToken, webpImages: webPImages)

      self.isJournalCreating = false
      // print("여행일지 등록 성공")
    } catch {
      self.isJournalCreating = false
      if let myError = error as? MyError {
        switch myError {
        case .apiError(let errorData):
          print("API Error Code: \(errorData.code), Message: \(errorData.message)")
        case .unknown(let message):
          print("Unknown error: \(message)")

        default:
          print("Error: something error during Creating journal")
        }
      } else {
        print("An unexpected error occurred: \(error)")
      }
    }

    //        journalProvider.requestPublisher(
    //            .create(token: idToken, title: title, startDate: startDate.toIntArray(), endDate: endDate.toIntArray(), visibility: privacyType.toString(), travelMateIds: travelMates.map{ $0.userId }, travelMateNames: travelMates.map{ $0.nickname }, dailyJournals: dailyJournalList, travelDuration: duration, imagesTotalCount: webpImages.count, images: webpImages))
    //        .filterSuccessfulStatusCodes()
    //        .sink { completion in
    //            switch completion {
    //            case .finished:
    //                self.isJournalCreating = false
    //                print("여행일지 등록 성공")
    //            case .failure(let error):
    //                self.isJournalCreating = false
    //
    //                guard let apiError = try? error.response?.map(ErrorData.self) else {
    //                    // error data decoding error handling
    //                    // unknown error
    //                    return
    //                }

    //if apiError.code == -11000 {
    //    self.appDataManager.refreshToken { success in
    //        // token error handling
    //        if success {
    //            self.registerTravelJournal()
    //            return
    //        }
    //    }
    //}
    // other api error handling
    //  1-3 실패 - 제목이 20자가 넘는 경우
    //  1-4 실패 - 여행 일지 콘텐츠가 15개 초과인 경우
    //  1-5 실패 - 여행 일지 콘텐츠의 이미지 제목이 비어있는 경우
    //  1-6 실패 - 여행 일지 콘텐츠의 이미지 제목 개수가 15개를 초과하는 경우
    //  1-7 실패 - 여행 이미지가 비어있는 경우
    //  1-8 실패 - 여행 이미지가 225개를 초과하는 경우
    //  1-9 실패 - 여행 일지의 시작일이 여행 일지의 종료일보다 늦을 경우
    //  1-10 실패 - 여행 일지 콘텐츠의 이미지 이름 개수와 실제 이미지 개수가 다를 경우
    //  1-11 실패 - 여행 일자보다 콘텐츠의 개수가 많을 경우
    //  1-12 실패 - 여행 콘텐츠 일자가 여행 시작일보다 이전이거나 여행 종료일보다 이후일 경우
    //  1-13 실패 - 여행 일자가 15일 초과인 경우
    //  1-14 실패 - 여행 친구 아이디가 등록되지 않은 사용자인 경우
    //  1-15 실패 - 여행 친구가 10명 초과인 경우
    //  1-16 실패 - 여행 일지 콘텐츠의 이름이 실제 이미지 파일 이름과 일치하지 않는 경우
    //  1-17 실패 - 위도와 경도 중에 하나만 null인 경우
    //  1-18 실패 - 위도와 경도의 개수가 다를 경우
    //  1-19 실패 - 유효하지 않은 장소 id인 경우
    //  1-20 실패 - 여행 일지 콘텐츠 이미지 저장에 실패하는 경우
    //  1-21 실패 - 여행 일지를 등록하려는 사용자가 없는 경우
    //  1-22 실패 - 유효하지 않은 토큰일 경우
    //            }
    //        } receiveValue: { _ in
    //        }.store(in: &subscription)

  }

  // MARK: Functions - daily journal

  func canAddMoreDailyJournals() -> Bool {
    return dailyJournalList.count < duration
  }

  func addDailyJournal(date: Date? = nil) {
    if let date = date {
      dailyJournalList.append(DailyTravelJournal(date: date))
    } else {
      dailyJournalList.append(DailyTravelJournal())
    }
  }

  func deleteDailyJournal(dailyJournal: DailyTravelJournal) {
    dailyJournalList = dailyJournalList.filter { $0 != dailyJournal }
  }

}
