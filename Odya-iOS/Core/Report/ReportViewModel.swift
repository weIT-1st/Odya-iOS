//
//  ReportViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/22.
//

import Combine
import CombineMoya
import Moya
import SwiftUI

class ReportViewModel: ObservableObject {
  // MARK: Properties
  
  /// provider
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: [.successResponseBody, .errorResponseBody]))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var reportRouter = MoyaProvider<ReportRouter>(plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  /// 기타 사유 텍스트
  @Published var otherReasonText: String = "" {
    didSet {
      validateOtherReasonTextCount()
    }
  }
  
  // Alert
  @Published var showAlert: Bool = false
  @Published var alertTitle: String = ""
  @Published var alertMessage: String = ""
  
  // MARK: - Post reports
  
  /// 신고하기
  func createReport(target: ReportTargetType, id: Int, reason: ReportReason) {
    var otherReason: String? = nil
    
    if reason == .other {
      otherReason = self.otherReasonText
    }
    
    switch target {
    case .placeReview:
      reportPlaceReview(id: id, reason: reason, otherReason: otherReason)
    case .travelJournal:
      reportTravelJournal(id: id, reason: reason, otherReason: otherReason)
    case .community:
      reportCommunity(id: id, reason: reason, otherReason: otherReason)
    }
  }
  
  /// 한줄리뷰 신고
  func reportPlaceReview(id: Int, reason: ReportReason, otherReason: String?) {
    reportRouter.requestPublisher(.reportPlaceReview(placeReviewId: id, reportReason: reason.status, otherReason: otherReason))
      .sink { completion in
        switch completion {
        case .finished:
          print("한줄리뷰 신고 \(id)")
          self.handleReportSuccess()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  /// 여행일지 신고
  func reportTravelJournal(id: Int, reason: ReportReason, otherReason: String?) {
    var otherReason: String? = nil
    
    if reason == .other {
      otherReason = self.otherReasonText
    }
    
    reportRouter.requestPublisher(.reportTravelJournal(travelJournalId: id, reportReason: reason.status, otherReason: otherReason))
      .sink { completion in
        switch completion {
        case .finished:
          print("여행일지 신고 \(id)")
          self.handleReportSuccess()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  /// 커뮤니티 신고
  func reportCommunity(id: Int, reason: ReportReason, otherReason: String?) {
    var otherReason: String? = nil
    
    if reason == .other {
      otherReason = self.otherReasonText
    }
    
    reportRouter.requestPublisher(.reportCommunity(communityId: id, reportReason: reason.status, otherReason: otherReason))
      .sink { completion in
        switch completion {
        case .finished:
          print("커뮤니티 신고 \(id)")
          self.handleReportSuccess()
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { _ in }
      .store(in: &subscription)
  }
  
  // MARK: - Helper functions
  
  /// 기타사유 글자수 제한
  func validateOtherReasonTextCount() {
    if otherReasonText.count > 20 {
      otherReasonText.removeLast()
    }
  }
  
  func handleReportSuccess() {
    alertTitle = "신고 완료"
    alertMessage = "신고가 정상적으로 접수되었습니다."
    showAlert = true
  }
  
  func handleErrorData(error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      alertTitle = "Error \(errorData.code)"
      alertMessage = errorData.message
      showAlert = true
    } else {
      alertTitle = "Unknown Error!"
      alertMessage = "알 수 없는 오류 발생"
      showAlert = true
    }
  }
}
