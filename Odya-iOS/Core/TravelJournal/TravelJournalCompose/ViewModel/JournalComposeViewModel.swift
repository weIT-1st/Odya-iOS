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

enum JournalComposeType {
  case create
  case edit
}

class JournalComposeViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()

  var webPImageManager = WebPImageManager()

  @AppStorage("WeITAuthToken") var idToken: String?

  // loading flag
  var isJournalCreating: Bool = false

  // travel journal data
  let journalId: Int
  let composeType: JournalComposeType

  var orgTitle: String
  var orgStartDate: Date
  var orgEndDate: Date
  var orgTravelMates: [TravelMate]
  var orgDailyJournals: [DailyJournal]
  var orgPrivacyType: PrivacyType

  @Published var title: String
  @Published var startDate: Date
  @Published var endDate: Date
  @Published var travelMates: [TravelMate]
  @Published var dailyJournalList: [DailyTravelJournal]
  @Published var privacyType: PrivacyType
  @Published var pickedJournalIndex: Int? = nil

  var duration: Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    if let day = components.day {
      return day + 1
    }
    return 0
  }

  // MARK: Init
  init(
    journalId: Int = -1,
    composeType: JournalComposeType,
    title: String = "",
    startDate: Date = Date(), endDate: Date = Date(),
    travelMates: [TravelMate] = [],
    dailyJournalList: [DailyJournal] = [],
    privacyType: PrivacyType = .global
  ) {
    self.journalId = journalId
    self.composeType = composeType

    self.orgTitle = title
    self.orgStartDate = startDate
    self.orgEndDate = endDate
    self.orgTravelMates = travelMates
    self.orgDailyJournals = dailyJournalList
    self.orgPrivacyType = privacyType

    self.title = title
    self.startDate = startDate
    self.endDate = endDate
    self.travelMates = travelMates
    self.dailyJournalList = []
    self.privacyType = privacyType

    dailyJournalList.forEach {
      self.dailyJournalList.append(
        DailyTravelJournal(date: $0.travelDate, dailyJournalId: $0.dailyJournalId, isOriginal: true)
      )
    }

  }

  // MARK: Functions - travel dates

  func setTravelDates(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }

  func setJournalDate(newDate: Date) {
    if let index = self.pickedJournalIndex {
      self.dailyJournalList[index].date = newDate
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

    // 여행 이미지 리사이징이 제대로 처리 안된 경우
    if dailyJournalList.flatMap({ $0.selectedImages }).contains(where: {
      max($0.image.size.width, $0.image.size.height) > 1024
    }) {
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
          token: idToken,
          title: title,
          startDate: startDate.toIntArray(),
          endDate: endDate.toIntArray(),
          visibility: privacyType.toString(),
          travelMateIds: travelMates.map { $0.userId! },
          travelMateNames: [],
          dailyJournals: dailyJournalList,
          travelDuration: duration,
          imagesTotalCount: webpImages.count,
          images: webpImages)
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
      
      // 사진 위치 정보 정리
      dailyJournalList.indices.forEach { idx in
        let images = dailyJournalList[idx].selectedImages
        dailyJournalList[idx].latitudes = images.compactMap {
          $0.location?.latitude
        }
        dailyJournalList[idx].longitudes = images.compactMap {
          $0.location?.longitude
        }
      }

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

  func updateTravelJournal(journalId: Int) {
    guard let idToken = self.idToken else {
      return
    }

    journalProvider.requestPublisher(
      .edit(
        token: idToken,
        journalId: journalId,
        title: title,
        startDate: startDate.toIntArray(),
        endDate: endDate.toIntArray(),
        visibility: privacyType.toString(),
        travelMateIds: travelMates.map { $0.userId! },
        travelMateNames: [],
        travelDuration: duration,
        newTravelMatesCount: travelMates.count)
    )
    .filterSuccessfulStatusCodes()
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        print("success")
      case .failure(let error):
        guard let errorData = try? error.response?.map(ErrorData.self) else {
          print("update travel journal error response decoding error")
          debugPrint(error)
          return
        }
        print(errorData.message)
      }
    } receiveValue: { _ in
    }
    .store(in: &subscription)
  }

  // MARK: Functions - save temporary
  
  func saveTempraryTravelJournal() {
    var tempData = TempTravelJournalData()
    tempData.dataExist = true
    tempData.journalId = self.journalId
    tempData.title = self.title
    tempData.startDate = self.startDate
    tempData.endDate = self.endDate
    tempData.mates = self.travelMates.map { $0.encodeToString() }
    tempData.privacyType = self.privacyType.toString()
    tempData.dailyJournals = self.dailyJournalList.map { $0.encodeToString() }
  }
  
  func loadTemporaryTravelJournal() {
    let tempData = TempTravelJournalData()
    
    if tempData.dataExist == false {
      return
    }
    
    self.title = tempData.title
    self.startDate = tempData.startDate
    self.endDate = tempData.endDate
    self.travelMates = tempData.mates.compactMap { $0.decodeToTravelMate() }
    self.privacyType = tempData.privacyType.toJournalPrivacyType()
    self.dailyJournalList = tempData.dailyJournals.compactMap { $0.decodeToDailyJournal() }
    
    deleteTemporaryTravelJournal()
  }
  
  func deleteTemporaryTravelJournal() {
    var tempData = TempTravelJournalData()
    
    tempData.dataExist = false
    tempData.journalId = -1
    tempData.title = ""
    tempData.startDate = Date()
    tempData.endDate = Date()
    tempData.mates = [String]()
    tempData.privacyType = ""
    tempData.dailyJournals = [String]()
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

  var isDailyJournalDeleting: Bool = false

  func deleteDailyJournalWithApi(dailyJournal: DailyTravelJournal) {
    guard let idToken = idToken else {
      return
    }

    if isDailyJournalDeleting {
      return
    }

    isDailyJournalDeleting = true
    journalProvider.requestPublisher(
      .deleteContent(
        token: idToken, journalId: self.journalId, contentId: dailyJournal.dailyJournalId)
    )
    .filterSuccessfulStatusCodes()
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        self.isDailyJournalDeleting = false
        self.deleteDailyJournal(dailyJournal: dailyJournal)
      case .failure(let error):
        self.isDailyJournalDeleting = false
        guard let apiError = try? error.response?.map(ErrorData.self) else {
          // error data decoding error handling
          // unknown error
          return
        }

        if apiError.code == -11000 {
          self.appDataManager.refreshToken { success in
            // token error handling
            if success {
              self.deleteDailyJournalWithApi(dailyJournal: dailyJournal)
              return
            }
          }
        }
      // other api error handling
      }
    } receiveValue: { _ in
    }
    .store(in: &subscription)
  }

}
