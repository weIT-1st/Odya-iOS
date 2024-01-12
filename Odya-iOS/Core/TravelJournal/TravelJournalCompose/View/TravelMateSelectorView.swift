//
//  TravelMateSelectorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

// MARK: Selected Mate View
struct SelectedMateView: View {
  let nickname: String
  let profile: ProfileData

  var body: some View {
    VStack(spacing: 12) {
      VStack(spacing: 0) {
        ProfileImageView(of: nickname, profileData: profile, size: .L)
          .padding(.top, 16)
        Image("smallGreyButton-x-filled")
          .offset(x: 27.5, y: -55)
          .frame(width: 0, height: 0)
      }
      Text(nickname)
        .detail2Style()
        .foregroundColor(.odya.label.normal)
        .lineLimit(1)
    }
    .frame(width: ComponentSizeType.L.ProfileImageSize)
  }
}

// MARK: Travel Mate Selector View
struct TravelMateSelectorView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var travelJournalEditVM: JournalComposeViewModel
  @EnvironmentObject var followHubVM: FollowHubViewModel

  @State var selectedTravelMates: [TravelMate] = []
  @State var searchedResults: [FollowUserData] = []
  @State var displayedFollowingUsers: [FollowUserData] = []

  @State var nameToSearch: String = ""
  @State var searchResultsDisplayed: Bool = false

  @State var isShowingTooManyMatesAlert: Bool = false

  @State var selectedMatesViewHeight: CGFloat = 16

  var body: some View {
    VStack(spacing: 0) {
      headerBar
      selectedMatesView

      VStack(spacing: 16) {
        FollowSearchBar(
          promptText: "닉네임 검색", nameToSearch: $nameToSearch,
          searchResultsDisplayed: $searchResultsDisplayed)
        followingUserListView
      }
      .padding(.vertical, 34)
      .background(Color.odya.elevation.elev2)
      .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))

    }.background(Color.odya.background.normal)
      .edgesIgnoringSafeArea(.bottom)
      .accentColor(Color.odya.brand.primary)
      .onAppear {
        selectedTravelMates = travelJournalEditVM.travelMates
        followHubVM.initFollowingUsers { result in
          if result {
            displayedFollowingUsers = followHubVM.followingUsers
          }
        }
      }
      .onChange(of: searchResultsDisplayed) { newValue in
        if newValue == false {
          displayedFollowingUsers = followHubVM.followingUsers
        }
      }
      .onChange(of: nameToSearch) { newValue in
        if searchResultsDisplayed {
          followHubVM.searchFollowingUsers(by: newValue) { success in
            displayedFollowingUsers = followHubVM.followingSearchResult
          }
        }
      }
      .refreshable {
        if searchResultsDisplayed {
          followHubVM.initFollowingUsers { _ in
            followHubVM.searchFollowingUsers(by: nameToSearch) { success in
              displayedFollowingUsers = followHubVM.followingSearchResult
            }
          }
        } else {
          followHubVM.initFollowingUsers { _ in
            displayedFollowingUsers = followHubVM.followingUsers
          }
        }
      }
      .alert("함께 간 친구는 10명까지 선택 가능합니다.", isPresented: $isShowingTooManyMatesAlert) {
        Button("확인") {
          isShowingTooManyMatesAlert = false
        }
      }
  }

  private var headerBar: some View {
    ZStack {
      CustomNavigationBar(title: "함께 간 친구")
      Button(action: {
        travelJournalEditVM.travelMates = selectedTravelMates
        dismiss()
      }) {
        Text("완료")
          .b1Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 36)
          .padding(.horizontal, 4)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.trailing, 12)
    }
  }

  private var selectedMatesView: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(selectedTravelMates) { mate in
          Button(action: {
            withAnimation {
              selectedTravelMates.removeAll { $0.userId == mate.userId }
            }
          }) {
            let profileData = ProfileData(
              profileUrl: mate.profileUrl ?? "",
              profileColor: mate.profileColor)
            SelectedMateView(
              nickname: mate.nickname ?? "",
              profile: profileData)
          }
          .padding(.trailing, 13)
        }
      }
      .padding(.bottom, 16)
      .frame(height: selectedMatesViewHeight)
      .animation(.easeInOut, value: selectedTravelMates)
    }
    .padding(.horizontal, GridLayout.side)
    .onChange(of: selectedTravelMates) { _ in
      withAnimation {
        selectedMatesViewHeight = selectedTravelMates.isEmpty ? 16 : 117
      }
    }
  }

  private var followingUserListView: some View {
    ScrollView {
      VStack(spacing: 16) {
        ForEach(displayedFollowingUsers) { user in
          HStack {
            UserIdentityLink(
              userId: user.userId,
              nickname: user.nickname,
              profileUrl: user.profile.profileUrl,
              isFollowing: true)
            Spacer()
            CustomIconButton(
              "plus-circle",
              color: isSelected(user.userId) ? .odya.label.inactive : .odya.brand.primary
            ) {
              if selectedTravelMates.count >= 10 {
                isShowingTooManyMatesAlert = true
              } else {
                let mate = TravelMate(
                  userId: user.userId,
                  nickname: user.nickname,
                  profile: user.profile,
                  isFollowing: true)
                // TODO: isFollowing 값 변경...!!
                selectedTravelMates.insert(mate, at: 0)
              }
            }
            .frame(height: 36)
            .disabled(isSelected(user.userId))
          }.frame(height: 36)
        }
      }.padding(.horizontal, GridLayout.side)
    }
  }
}

extension TravelMateSelectorView {
  func isSelected(_ userId: Int) -> Bool {
    return selectedTravelMates.contains { $0.userId == userId }
  }
}

//struct TravelMateSelectorView_Previews: PreviewProvider {
//  static var previews: some View {
//    TravelMateSelectorView(travelJournalEditVM: TravelJournalEditViewModel())
//  }
//}
