//
//  DailyJournalDeletionButtonViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/06.
//

import Combine
import CombineMoya
import FirebaseAuth
import Moya
import SwiftUI

class DailyJournalDeletionButtonViewModel: ObservableObject {
  // moya
  private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
  private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
  private var subscription = Set<AnyCancellable>()
  @Published var appDataManager = AppDataManager()

  @AppStorage("WeITAuthToken") var idToken: String?

  var isJournalDeleting: Bool = false

  
}
