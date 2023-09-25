//
//  FollowHubView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/10.
//

import SwiftUI


// MARK: Follow User List View

struct FollowUserListView: View {
    @EnvironmentObject var followHubVM: FollowHubViewModel
    @Binding var displayedUsers: [FollowUserData]
    
    init(of users: Binding<[FollowUserData]>) {
        self._displayedUsers = users
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 팔로워/팔로잉 유저가 없는 경우 바로 추천 뷰
                if shouldShowUserSuggestion() {
                    UserSuggestionView()
                        .environmentObject(followHubVM)
                }
                
                showList(of: displayedUsers)
                
                // 더 많은 유저를 로딩할 때 나오는 로딩 뷰
                if followHubVM.isLoading && !followHubVM.isRefreshing {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
    
    /// 팔로워/팔로잉 리스트 뷰 & 알 수도 있는 친구 추천 뷰
    /// 마지막 팔로잉/팔로워 유저가 나오면 fetch api 호출(무한스크롤)
    private func showList(of users: [FollowUserData]) -> some View {
        ForEach(users) { user in
            Group {
                switch followHubVM.currentFollowType {
                case .following:
                    FollowingUserRowView(of: user)
                        .environmentObject(followHubVM)
                case .follower:
                    FollowerUserRowView(of: user)
                        .environmentObject(followHubVM)
                }
            }
            .onAppear {
                if users.last == user {
                    followHubVM.fetchMoreSubject.send()
                }
            }
            
            if shouldShowUserSuggestion(before: user) {
                UserSuggestionView()
                    .environmentObject(followHubVM)
            }
        }
    }
    
    /// 알 수도 있는 친구 뷰를 띄워야 하는지 확인
    /// 15번째 팔로잉/팔로워 뒤에 추천이 나옴, 친구 수가 15명 미만이면 가장 마지막 친구 뒤에 나옴
    /// parameter user가 nil이면서 displayedUsers가 비어있을 경우 즉 팔로워/팔로잉 친구가 없을 경우 추천이 나옴
    private func shouldShowUserSuggestion(before user: FollowUserData? = nil) -> Bool {
        let maxCount = 15
        let usersCount = displayedUsers.count
        let indexBeforeSuggestion = min(maxCount, usersCount) - 1
        
        guard let user = user else {
            return indexBeforeSuggestion < 0
        }
            
        if indexBeforeSuggestion >= 0 {
            return displayedUsers[indexBeforeSuggestion] == user
        }
        return false
    }
}

struct SearchedUserListView: View {
    @EnvironmentObject var followHubVM: FollowHubViewModel
    
    let nameToSearch: String
    @State var searchedFollowingUser: [FollowUserData] = []
    @State var searchedFollowerUser: [FollowUserData] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                showList(of: searchedFollowingUser, followType: .following)
                showList(of: searchedFollowerUser, followType: .follower)
                
                // 검색 결과를 로딩할 때 나오는 로딩 뷰
                if followHubVM.isLoadingSearchResult {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .onAppear {
            (searchedFollowingUser, searchedFollowerUser) = followHubVM.searchFollowerUsers(by: nameToSearch)
        }
        .onChange(of: nameToSearch) { newValue in
            (searchedFollowingUser, searchedFollowerUser) = followHubVM.searchFollowerUsers(by: newValue)
        }
        .refreshable {
            followHubVM.initFollowingUsers { _ in
                followHubVM.initFollowerUsers { _ in
                    (searchedFollowingUser, searchedFollowerUser) = followHubVM.searchFollowerUsers(by: nameToSearch)
                }
            }
        }
    }
    
    private func showList(of users: [FollowUserData], followType: FollowType) -> some View {
        ForEach(users) { user in
            switch followType {
            case .following:
                FollowingUserRowView(of: user)
                    .environmentObject(followHubVM)
            case .follower:
                FollowerUserRowView(of: user)
                    .environmentObject(followHubVM)
            }
        }
    }
}

// MARK: Follow Search Bar

struct FollowSearchBar: View {
    var promptText: String
    @EnvironmentObject var followHubVM: FollowHubViewModel
    
    @State private var input: String = ""
    @Binding var nameToSearch: String
    @Binding var searchResultsDisplayed: Bool
//    @State private var isChanged: Bool = true
    
    var body: some View {
        HStack {
            TextField(
                input, text: $input,
                prompt: Text(promptText)
                    .foregroundColor(.odya.label.inactive)
            )
            .foregroundColor(input != nameToSearch ? .odya.label.normal : .odya.label.inactive)
            .b1Style()
            
            if input != "" {
                IconButton("smallGreyButton-x-filled") {
                    input = ""
                    nameToSearch = ""
                    searchResultsDisplayed = false
                }
            }
            IconButton("search") {
                nameToSearch = input
                searchResultsDisplayed = true
            }.disabled(input.count == 0 || input == nameToSearch)
        }
        .modifier(CustomFieldStyle(backgroundColor: Color.odya.elevation.elev4))
        .padding(.horizontal, GridLayout.side)
        .onChange(of: input) { newValue in
            if newValue == "" {
                searchResultsDisplayed = false
            }
        }
    }
}

// MARK: Follow Hub View

struct FollowHubView: View {
    @ObservedObject var followHubVM: FollowHubViewModel
    @State var displayedUsers: [FollowUserData] = []
    @State var nameToSearch: String = ""
    @State var searchResultsDisplayed: Bool = false
    
    init(token: String, userID: Int, followCount: FollowCount) {
        self.followHubVM = FollowHubViewModel(token: token, userID: userID, followCount: followCount)
    }
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "친구 관리")
            FollowSearchBar(promptText: "친구를 찾아보세요!", nameToSearch: $nameToSearch, searchResultsDisplayed: $searchResultsDisplayed)
                .environmentObject(followHubVM)
            
            if !searchResultsDisplayed {
                followTypeToggle
                    .padding(.vertical, 20)
                FollowUserListView(of: $displayedUsers)
                    .environmentObject(followHubVM)
                    .refreshable {
                        followHubVM.isRefreshing = true
                        switch followHubVM.currentFollowType {
                        case .following:
                            followHubVM.initFollowingUsers() { result in
                                if result {
                                    displayedUsers = followHubVM.followingUsers
                                }
                            }
                        case .follower:
                            followHubVM.initFollowerUsers() { result in
                                if result {
                                    displayedUsers = followHubVM.followerUsers
                                }
                            }
                        }
                    }
            } else {
                SearchedUserListView(nameToSearch: nameToSearch)
                    .padding(.top, 20)
                    .environmentObject(followHubVM)
            }
        }
        .background(Color.odya.background.normal)
        .onAppear{
            followHubVM.initFollowingUsers() { result in
                if followHubVM.currentFollowType == .following && result {
                    displayedUsers = followHubVM.followingUsers
                }
            }
            followHubVM.initFollowerUsers() { result in
                if followHubVM.currentFollowType == .follower && result {
                    displayedUsers = followHubVM.followerUsers
                }
            }
        }
        .onChange(of: followHubVM.currentFollowType) { newValue in
            displayedUsers = newValue == .following
            ? followHubVM.followingUsers : followHubVM.followerUsers
        }
    }
    
    private var followTypeToggle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 190, height: 40)
                .foregroundColor(.odya.elevation.elev5)
            
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 91.7, height: 36)
                .foregroundColor(.odya.brand.primary)
                .offset(x: followHubVM.currentFollowType == .following ? 47.15 : -47.15)
                .animation(.easeInOut, value: followHubVM.currentFollowType)
            
            HStack(spacing: 2) {
                Button(action: {
                    followHubVM.currentFollowType = .follower
                }) {
                    Text("팔로워")
                        .b1Style()
                        .foregroundColor(.odya.label.inactive)
                        .padding(10)
                        .frame(width: 92)
                }
                Button(action: {
                    followHubVM.currentFollowType = .following
                }) {
                    Text("팔로잉")
                        .b1Style()
                        .foregroundColor(.odya.label.inactive)
                        .padding(10)
                        .frame(width: 92)
                }
            }.frame(height: 40)
        }
    }
}

//struct FollowListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowHubView(token: "testIdToken", userID: 1, followCount: FollowCount())
//    }
//}
