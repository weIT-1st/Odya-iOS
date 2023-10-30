//
//  FeedViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/12.
//

import SwiftUI
import Combine
import Moya

final class FeedViewModel: ObservableObject {
    // MARK: Properties
    
    /// Provider
    @AppStorage("WeITAuthToken") var idToken: String?
    private let logPlugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
    private lazy var communityProvider = MoyaProvider<CommunityRouter>(session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
    private var subscription = Set<AnyCancellable>()
    
    /// 피드 내용, 페이지 정보 저장
    struct FeedState {
        var content: [FeedContent] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
    
    @Published private(set) var state = FeedState()
        
    // MARK: - Read
    
    /// 커뮤니티 전체게시글 조회
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        communityProvider.requestPublisher(.getAllCommunity(size: 10, lastId: nil, sortType: FeedSortType.lastest.rawValue))
            .sink { completion in
                switch completion {
                case .finished:
                    print("피드 조회 완료")
                case .failure(let error):
                    if let errorData = try? error.response?.map(ErrorData.self) {
                        print(errorData.message)
                    }
                    self.state.canLoadNextPage = false
                }
            } receiveValue: { response in
                if let data = try? response.map(Feed.self) {
                    self.state.content += data.content
                    self.state.page += 1
                    self.state.canLoadNextPage = data.hasNext
                    print(self.state.content)
                }
            }
            .store(in: &subscription)
    }
    
    /// 전체글 새로고침
    func refreshFeed() {
        self.state = FeedState()
        fetchNextPageIfPossible()
    }
}
