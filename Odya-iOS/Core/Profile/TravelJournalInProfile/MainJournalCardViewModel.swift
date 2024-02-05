//
//  MainJournalCardViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/05.
//

import Combine
import Moya
import SwiftUI

final class MainJournalCardViewModel: ObservableObject {
  // MARK: Properties
  
  @AppStorage("WeITAuthToken") var idToken: String?
  // plugins
  private let logPlugin: PluginType = CustomLogPlugin()
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  // providers
  lazy var journalProvider = MoyaProvider<TravelJournalRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin])
  var subscription = Set<AnyCancellable>()
  
  var journalDetail: TravelJournalDetailData?
  @Published var title: String = ""
  @Published var dateString: String = ""
  @Published var mates: [travelMateSimple] = []
  @Published var content: String = ""
  @Published var myDailyJournals: [DailyJournal] = []
  
  // MARK: Helper functions
  
  func fetchTravelJournalDetail(journalId: Int) {
    journalProvider.requestPublisher(.searchById(token: idToken ?? "", journalId: journalId))
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.handleErrorData(error: error)
        }
      } receiveValue: { response in
        if let data = try? response.map(TravelJournalDetailData.self) {
          self.journalDetail = data
          self.myDailyJournals = data.dailyJournals
          if let journalData = self.journalDetail {
            self.title = journalData.title
            self.dateString = "\(journalData.travelStartDate.dateToString(format: "MM.dd")) ~ \(journalData.travelEndDate.dateToString(format: "MM.dd"))"
            self.mates = journalData.travelMates.map { travelMateSimple(username: $0.nickname ?? "", profileUrl: $0.profileUrl) }
            self.content = journalData.dailyJournals.first?.content ?? ""
          }
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
