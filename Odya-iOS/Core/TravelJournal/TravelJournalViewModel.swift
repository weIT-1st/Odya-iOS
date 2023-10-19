//
//  MyJournalsViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/18.
//

import SwiftUI
import Combine
import CombineMoya
import FirebaseAuth
import Moya

class MyJournalsViewModel: ObservableObject {
    // moya
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var journalProvider = MoyaProvider<TravelJournalRouter>(plugins: [plugin])
    private var subscription = Set<AnyCancellable>()
    @Published var appDataManager = AppDataManager()

    // user info
    @AppStorage("WeITAuthToken") var idToken: String?
    @Published var nickname: String = MyData().nickname
    @Published var profile: ProfileData = MyData().profile.decodeToProileData()
    var userId: Int = MyData().userID
    
    // loadingFlag
    var isMyJournalsLoading: Bool = false
    
    // travel journals
//    @Published var randomJournal: TravelJournalData
    @Published var myJournals: [TravelJournalData] = []
    var lastIdOfMyJournals: Int? = nil
    var hasNextMyJournals: Bool = true
    
    @Published var fravoriteJournals: [TravelJournalData] = []
    @Published var taggedJournals: [TravelJournalData] = []
    // 내가 쓴 한글리뷰 리스트
    
    // 모두 비동기적으로 가져올 것
    // refresh, onAppear -> fetch
    // 무한스크롤 - 내 여행일지, 즐겨찾는 여행일지, 태그된 여행일지
    // 내 여행일지랑 한줄리뷰는 - 10개 정도씩 가져오고 더보기 같은 버튼이 있어야 될 거 같은데...? 아니다 가능은 하겠다
    // 즐겨찾기랑 태그는 가로스크롤이니까 땡기면 더 가져오면 되는데
    
    func getMyData() {
        let myData = MyData()
        self.nickname = myData.nickname
        self.profile = myData.profile.decodeToProileData()
        self.userId = myData.userID
    }
    
    func fetchDataAsync() async {
        guard let idToken = idToken else {
            return
        }
        
        getMyJournals(idToken: idToken)
    }
    
    func getMyJournals(idToken: String) {
        if isMyJournalsLoading || !hasNextMyJournals {
            return
        }
        
        self.isMyJournalsLoading = true
        journalProvider.requestPublisher(.getMyJournals(token: idToken, size: nil, lastId: self.lastIdOfMyJournals))
            .filterSuccessfulStatusCodes()
            .sink { completion in
                switch completion {
                case .finished:
                    self.isMyJournalsLoading = false
                case .failure(let error):
                    self.isMyJournalsLoading = false
                    
                    guard let apiError = try? error.response?.map(ErrorData.self) else {
                        // error data decoding error handling
                        // unknown error
                        return
                    }
                    
                    if apiError.code == -11000 {
                        self.appDataManager.refreshToken { success in
                            // token error handling
                            if success {
                                self.getMyData()
                                return
                            }
                            
                        }
                        
                    }
                    // other api error handling
                }
            } receiveValue: { response in
                do {
                    let responseData = try response.map(TravelJournalResponse.self)
                    self.hasNextMyJournals = responseData.hasNext
                    self.myJournals = responseData.content
                } catch {
                    return
                }
            }.store(in: &subscription)
    }
    
    
    // onAppear -> fetch All, update myData
    //
    
}
