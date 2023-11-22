//
//  TravelJournalDetailViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/30.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class TravelJournalDetailViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()

  @AppStorage("WeITAuthToken") var idToken: String?

  var isJournalDetailLoading: Bool = false
  var isJournalDeleting: Bool = false
  var deletingDailyJournalId: [Int] = []

  @Published var journalDetail: TravelJournalDetailData? = nil
  @Published var isMyJournal: Bool = false
  @Published var isFeedType: Bool = true
  @Published var isAllExpanded: Bool = false
  @Published var isEditViewShowing: Bool = false

  @Published var editedDailyJournal: DailyJournal? = nil

  // MARK: Functions
  func getJournalDetail(journalId: Int) {
    guard let idToken = idToken else {
      return
    }

    if isJournalDetailLoading {
      return
    }

    journalProvider.requestPublisher(.searchById(token: idToken, journalId: journalId))
      .filterSuccessfulStatusCodes()
      .sink { completion in
        switch completion {
        case .finished:
          self.isJournalDetailLoading = false
        case .failure(let error):
          self.isJournalDetailLoading = false

          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            // unknown error
            return
          }

          if apiError.code == -11000 {
            self.appDataManager.refreshToken { success in
              // token error handling
              if success {
                self.getJournalDetail(journalId: journalId)
                return
              }
            }
          }
        // other api error handling
        }
      } receiveValue: { response in
        do {
          let responseData = try response.map(TravelJournalDetailData.self)
          self.journalDetail = responseData
        } catch {
          return
        }
      }.store(in: &subscription)

  }

  // MARK: Delete
  func deleteJournal(
    journalId: Int,
    completion: @escaping (Bool, String) -> Void
  ) {
    guard let idToken = idToken else {
      return
    }

    guard journalDetail != nil else {
      return
    }

    if isJournalDeleting {
      return
    }

    isJournalDeleting = true

    journalProvider.requestPublisher(.delete(token: idToken, journalId: journalId))
      .filterSuccessfulStatusCodes()
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isJournalDeleting = false
          completion(true, "")
        case .failure(let error):
          self.isJournalDeleting = false

          guard let apiError = try? error.response?.map(ErrorData.self) else {
            // error data decoding error handling
            // unknown error
            completion(false, "예기치 못한 오류의 발생으로 삭제를 실패하였습니다.")
            return
          }

          if apiError.code == -11000 {
            self.appDataManager.refreshToken { success in
              // token error handling
              if success {
                self.deleteJournal(journalId: journalId) { success, errMsg in
                  completion(success, errMsg)
                }
                return
              }
            }
          }
          // other api error handling
          completion(false, apiError.message)
        }
      } receiveValue: { _ in
      }
      .store(in: &subscription)

  }

  func deleteDailyJournal(
    journalId: Int, dailyJournalId: Int,
    completion: @escaping (Bool, String) -> Void
  ) {
    guard let idToken = idToken else {
      return
    }

    guard let journalDetail = journalDetail else {
      return
    }

    if deletingDailyJournalId.contains(dailyJournalId) {
      return
    }

    if journalDetail.dailyJournals.count <= 1 {
      completion(false, "최소 1개의 여행일정이 필요합니다.")
      return
    }

    deletingDailyJournalId.append(dailyJournalId)

    journalProvider.requestPublisher(
      .deleteContent(token: idToken, journalId: journalId, contentId: dailyJournalId)
    )
    .filterSuccessfulStatusCodes()
    .sink { apiCompletion in
      switch apiCompletion {
      case .finished:
        self.deletingDailyJournalId = self.deletingDailyJournalId.filter { $0 != journalId }
        self.journalDetail?.dailyJournals = journalDetail.dailyJournals.filter {
          $0.dailyJournalId != journalId
        }
        completion(true, "")
      case .failure(let error):
        self.deletingDailyJournalId = self.deletingDailyJournalId.filter { $0 != journalId }

        guard let apiError = try? error.response?.map(ErrorData.self) else {
          // error data decoding error handling
          // unknown error
          completion(false, "예기치 못한 오류의 발생으로 삭제를 실패하였습니다.")
          return
        }

        if apiError.code == -11000 {
          self.appDataManager.refreshToken { success in
            // token error handling
            if success {
              self.deleteDailyJournal(journalId: journalId, dailyJournalId: dailyJournalId) {
                success, errMsg in
                completion(success, errMsg)
              }
              return
            }
          }
        }
        // other api error handling
        completion(false, apiError.message)
      }
    } receiveValue: { _ in
    }
    .store(in: &subscription)

  }

}
