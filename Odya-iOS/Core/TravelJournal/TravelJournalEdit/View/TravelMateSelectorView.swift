//
//  TravelMateSelectorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

struct SelectedMateView: View {
  let mate: FollowUserData

  var body: some View {
    VStack(spacing: 12) {
      VStack(spacing: 0) {
        ProfileImageView(of: mate.nickname, profileData: mate.profile, size: .L)
          .padding(.top, 16)
        Image("smallGreyButton-x-filled")
          .offset(x: 27.5, y: -55)
          .frame(width: 0, height: 0)
      }
      Text(mate.nickname)
        .detail2Style()
        .foregroundColor(.odya.label.normal)
        .lineLimit(1)
    }
    .frame(width: ComponentSizeType.L.ProfileImageSize)
  }
}

// 테스트를 위한 임시 뷰
struct UserProfileView: View {
  //  let userData: FollowUserData
  let userId: Int
  let nickname: String

  var body: some View {
    Text(nickname)
  }
}

struct TravelMateSelectorView: View {
  @Environment(\.presentationMode) private var presentationMode
  @EnvironmentObject var travelJournalEditVM: TravelJournalEditViewModel

  @ObservedObject var followHubVM: FollowHubViewModel

  @State var selectedTravelMates: [FollowUserData] = []
  @State var searchedResults: [FollowUserData] = []
  @State var displayedFollowingUsers: [FollowUserData] = []

  @State var nameToSearch: String = ""
  @State var searchResultsDisplayed: Bool = false

  @State var isShowingTooManyMatesAlert: Bool = false

  @State var selectedMatesViewHeight: CGFloat = 16

  init(token: String, userId: Int) {
    self.followHubVM = FollowHubViewModel(token: token, userID: userId, followCount: FollowCount())
  }

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
      }.accentColor(Color.odya.brand.primary)
  }

  private var headerBar: some View {
    ZStack {
      CustomNavigationBar(title: "함께 간 친구")
      Button(action: {
        travelJournalEditVM.travelMates = selectedTravelMates
        presentationMode.wrappedValue.dismiss()
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
              selectedTravelMates.removeAll { $0 == mate }
            }
          }) {
            SelectedMateView(mate: mate)
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
            FollowUserView(user: user)
            Spacer()
            IconButton("plus-circle") {
              if selectedTravelMates.count >= 10 {
                isShowingTooManyMatesAlert = true
              } else {
                selectedTravelMates.insert(user, at: 0)
              }
            }
            .colorMultiply(
              selectedTravelMates.contains { mate in
                mate.userId == user.userId
              } ? .odya.label.inactive : .odya.brand.primary
            )
            .frame(height: 36)
            .disabled(
              selectedTravelMates.contains { mate in
                mate.userId == user.userId
              })
          }.frame(height: 36)
        }
      }.padding(.horizontal, GridLayout.side)
    }
  }

}

//struct TravelMateSelectorView_Previews: PreviewProvider {
//  static var previews: some View {
//    TravelMateSelectorView(travelJournalEditVM: TravelJournalEditViewModel())
//  }
//}