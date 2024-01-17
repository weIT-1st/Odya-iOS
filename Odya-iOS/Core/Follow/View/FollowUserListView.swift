//
//  FollowUserListView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/25.
//

import SwiftUI

// MARK: Follow User List View

extension FollowHubView {
  
  /// 팔로잉/팔로워 리스트 뷰
  /// 일정 구간에서 알 수도 있는 친구 추천하는 뷰를 띄워줌
  var FollowUserListView: some View {
    ScrollView {
      VStack(spacing: 16) {
        showList(of: displayedUsers)

        // 더 많은 유저를 로딩할 때 나오는 로딩 뷰
        if followHubVM.isLoading && !followHubVM.isRefreshing {
          Spacer()
          ProgressView()
          Spacer()
        }

        // 팔로워/팔로잉 유저가 없는 경우 바로 추천 뷰
        if shouldShowUserSuggestion() {
          UserSuggestionView()
            .environmentObject(followHubVM)
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
          UserIdentityRowWithFollowing(of: user)
        case .follower:
          if isMyFollowHub {
            FollowerUserRowView(of: user)
          } else {
            UserIdentityRowWithFollowing(of: user)
          }
        }
      }
      .padding(.horizontal, GridLayout.side)
      .onAppear {
        if users.last == user {
          followHubVM.fetchMoreSubject.send(userId)
        }
      }

      if shouldShowUserSuggestion(before: user) {
        UserSuggestionView()
          .environmentObject(followHubVM)
      }
    }
  }

  /// 알 수도 있는 친구 뷰를 띄워야 하는지 확인
  /// 8번째 팔로잉/팔로워 뒤에 추천이 나옴, 친구 수가 15명 미만이면 가장 마지막 친구 뒤에 나옴
  /// parameter user가 nil이면서 displayedUsers가 비어있을 경우 즉 팔로워/팔로잉 친구가 없을 경우 추천이 나옴
  private func shouldShowUserSuggestion(before user: FollowUserData? = nil) -> Bool {
    let maxCount = 8
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

// MARK: Searched User List View

///  닉네임으로 검색된 팔로워/팔로잉 결과 리스트를 보여주는 뷰
struct SearchedUserListView: View {
  @EnvironmentObject var followHubVM: FollowHubViewModel
  
  let userId: Int
  let nameToSearch: String
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        showList(of: followHubVM.followingSearchResult,
                 showDeletionButton: false)
        showList(of: followHubVM.followerSearchResult,
                 showDeletionButton: userId == MyData.userID)
        
        // 검색 결과를 로딩할 때 나오는 로딩 뷰
        if followHubVM.isLoadingSearchResult {
          Spacer()
          ProgressView()
          Spacer()
        }
      }.padding(.horizontal, GridLayout.side)
    }
    .onAppear {
      followHubVM.searchFollowUsers(by: nameToSearch, userId: userId)
    }
    .onChange(of: nameToSearch) { newValue in
      followHubVM.searchFollowUsers(by: newValue, userId: userId)
    }
    .refreshable {
      followHubVM.initSearchData()
      followHubVM.searchFollowUsers(by: nameToSearch, userId: userId)
    }
  }


  private func showList(of users: [FollowUserData], showDeletionButton: Bool) -> some View {
    ForEach(users) { user in
      if showDeletionButton {
        FollowerUserRowView(of: user)
      } else {
        UserIdentityRowWithFollowing(of: user)
      }
    }
  }
}
