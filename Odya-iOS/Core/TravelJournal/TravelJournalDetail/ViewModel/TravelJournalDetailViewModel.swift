//
//  TravelJournalDetailViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/30.
//

import SwiftUI
import Combine
import CombineMoya
import FirebaseAuth
import Moya

class TravelJournalDetailViewModel: ObservableObject {
    // moya
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    @Published var appDataManager = AppDataManager()
    
    @AppStorage("WeITAuthToken") var idToken: String?
    
    var isJournalDetailLoading: Bool = false
    
    @Published var journalDetail: TravelJournalDetailData? = nil
    
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
    
}
