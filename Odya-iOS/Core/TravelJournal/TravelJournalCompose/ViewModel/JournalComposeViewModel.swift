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
  var showCompletePopup: Bool = false

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

  // MARK: travel dates

  func setTravelDates(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }

  func setJournalDate(newDate: Date) {
    if let index = self.pickedJournalIndex {
      self.dailyJournalList[index].date = newDate
    }
  }

  // MARK: validate

  private func validateDailyJounral(_ dailyJournal: DailyTravelJournal) -> (Bool, String) {
    if dailyJournal.isOriginal {
      return (true, "")
    }
    
    // date
    guard let date = dailyJournal.date else {
      return (false, "여행 콘텐츠 날짜는 여행 일정 내에 포함되어야 합니다.")
    }
    if date < startDate || date > endDate {
      return (false, "여행 콘텐츠 날짜는 여행 일정 내에 포함되어야 합니다.")
    }

    // images
    // 여행 일지 콘텐츠의 이미지 제목 개수가 15개를 초과하는 경우
    if dailyJournal.selectedImages.count > 15
        || dailyJournal.selectedImages.contains(where: { $0.imageName == "" }){
      return (false, "여행 일지 콘텐츠 이미지는 최소 1개, 최대 15개까지 등록 가능합니다.")
    }
    
    // 여행 일지 콘텐츠의 이미지 제목이 비어있는 경우
    if dailyJournal.selectedImages.contains(where: { $0.imageName == "" }) {
      return (false, "여행 일지 콘텐츠 이미지는 최소 1개, 최대 15개까지 등록 가능합니다.")
    }
    
    return (true, "")
  }
  
  
  func validateTravelJournal() -> (Bool, String) {
    // 제목이 20자가 넘는 경우
    if title.isEmpty || title.countCharacters() > 20 {
      return (false, "여행 일지 제목은 최소 1자, 최대 20자까지 입력 가능합니다.")
    }
    
    // 여행 일지의 시작일이 여행 일지의 종료일보다 늦을 경우
    if startDate > endDate {
      return (false, "여행 기간이 유효하지 않습니다. 시작 날짜를 종료 날짜 이전으로 설정해주세요.")
    }
    
    // 여행 일자가 15일 초과인 경우
    if duration > 15 {
      return (false, "여행 일정을 15일 이내로 설정해주세요.")
    }
    
    // 여행 친구가 10명 초과인 경우
    if travelMates.count > 10 {
      return (false, "함께 간 친구는 최대 10명까지 등록 가능합니다.")
    }
    
    // 여행 일지 콘텐츠가 15개 초과인 경우
    if dailyJournalList.count > 15 {
      return (false, "여행 일지 콘텐츠는 최대 15개까지 등록 가능합니다.")
    }
    
    // 여행 일자보다 콘텐츠의 개수가 많을 경우
    if duration < dailyJournalList.count {
      return (false, "하루에 한 개의 콘텐츠만 등록 가능합니다.")
    }

    // 여행 이미지가 225개를 초과하는 경우
    if dailyJournalList.map({ $0.selectedImages.count }).reduce(0, +) > 225 {
      return (false, "여행 일지 콘텐츠 이미지는 최소 1개, 최대 15개까지 등록 가능합니다.")
    }

    for dailyJournal in dailyJournalList {
      let ret = self.validateDailyJounral(dailyJournal)
      if ret.0 == false {
        return ret
      }
    }
    return (true, "")
  }

  // MARK: create
  private func createJournalAPI(idToken: String, webpImages: [(data: Data, name: String)]) async throws
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
            self.showCompletePopup = true
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
    guard let idToken = idToken else {
      return
    }
    
    self.isJournalCreating = true
    
    // 등록 중 노티 보내기
    NotiManager().sendLocalNoti(notiMsg: "\(title) 여행일지를 등록 중입니다.")
    
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
      // 등록 완료 노티 보내기
      NotiManager().sendLocalNoti(notiMsg: "\(title) 여행일지를 성공적으로 등록하였습니다.")
      
    } catch {
      self.isJournalCreating = false
      // 등록 실패 노티 보내기
      NotiManager().sendLocalNoti(notiMsg: "\(title) 여행일지 등록을 실패하였습니다.")
    }
  }
  
  // MARK: update

  func updateTravelJournal(journalId: Int) async {
    guard let idToken = self.idToken else {
      return
    }
    
    var publishers: [AnyPublisher<Response, MoyaError>] = []
    
    // 등록 중 노티 보내기
    NotiManager().sendLocalNoti(notiMsg: "\(title) 여행일지를 수정 중입니다.")
    
    publishers.append(updateTravelJournalApi(idToken: idToken))
    
    // add daily journals
    let newDailyJournals = dailyJournalList.filter { !$0.isOriginal }
    
    for dailyJournal in newDailyJournals {
      // webp 변환하기
      let webpImageList = await webPImageManager.processImages(images: dailyJournal.selectedImages)

      // 사진 위치 정보 정리
      let latitudes = dailyJournal.selectedImages.compactMap {
        $0.location?.latitude
      }
      let longitudes = dailyJournal.selectedImages.compactMap {
        $0.location?.longitude
      }
      
      publishers.append(addDailyJournalWithApi(idToken: idToken,
                                               dailyJournal: dailyJournal,
                                               webpImages: webpImageList,
                                               latitudes: latitudes,
                                               longitudes: longitudes))
    }
      
    
    // delete daily journals
    let leftOrgJournalIds = Set(dailyJournalList.filter{ $0.isOriginal }.map{ $0.dailyJournalId })
    let deletedJournals = orgDailyJournals.filter{ !leftOrgJournalIds.contains($0.dailyJournalId) }
    
    for dailyJournal in deletedJournals {
      publishers.append(deleteDailyJournalsWithApi(idToken: idToken,
                                                   dailyJournalId: dailyJournal.dailyJournalId))
    }
    
    // api response
    Publishers.MergeMany(Array(publishers))
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        // 등록 완료 노티 보내기
        NotiManager().sendLocalNoti(notiMsg: "\(self.title) 여행일지를 성공적으로 수정하였습니다.")
      case .failure(let error):
        // 등록 실패 노티 보내기
        NotiManager().sendLocalNoti(notiMsg: "\(self.title) 여행일지 수정을 실패하였습니다.")
        guard let errorData = try? error.response?.map(ErrorData.self) else {
          print("update travel journal error response decoding error")
          debugPrint(error)
          return
        }
        print(errorData.message)
      }
    } receiveValue: { _ in }
    .store(in: &subscription)
  }
  
  private func updateTravelJournalApi(idToken: String) -> AnyPublisher<Response, MoyaError> {
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
    .eraseToAnyPublisher()
  }
  
  private func addDailyJournalWithApi(idToken: String, 
                                      dailyJournal: DailyTravelJournal,
                                      webpImages: [(data: Data, imageName: String)],
                                      latitudes: [Double],
                                      longitudes: [Double]) -> AnyPublisher<Response, MoyaError> {
    journalProvider.requestPublisher(
      .createContent(token: idToken,
                     journalId: journalId,
                     content: dailyJournal.content,
                     placeId: dailyJournal.placeId,
                     latitudes: latitudes,
                     longitudes: longitudes,
                     date: dailyJournal.date?.toIntArray() ?? [],
                     images: webpImages)
    ).eraseToAnyPublisher()
  }

  private func deleteDailyJournalsWithApi(idToken: String,
                                          dailyJournalId: Int) -> AnyPublisher<Response, MoyaError> {
    journalProvider.requestPublisher(
      .deleteContent(
        token: idToken,
        journalId: journalId,
        contentId: dailyJournalId)
    ).eraseToAnyPublisher()
  }

  // MARK: save temporary
  
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
  
  // MARK: daily journal

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
