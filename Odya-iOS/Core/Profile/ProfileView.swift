//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

// MARK: Stack View Type
/// NavigationStack으로 이동할 뷰 타입
enum StackViewType: Hashable {
  /// 환경설정
  case settingView
  /// 친구관리 뷰
  case followHubView
  /// 인생샷 등록을 위한 유저 사진 피커 뷰
  case potoRegisterView
  /// 대표 여행일지 등록을 위한 뷰
  case mainJournalRegisterView
  /// 프로필 뷰에서 여행일지 클릭 시 이동하는 여행일지 디테일 뷰
  case journalDetail(journalId: Int, nickname: String)
  /// 내 커뮤니티 활동 뷰
  case myCommunity
}

struct ProfileView: View {
  // viewModel
  @StateObject var profileVM = ProfileViewModel()
  @StateObject var followButtonVM = FollowButtonViewModel()
  @ObservedObject var bookmarkedJournalsVM: JournalsInProfileViewModel
  @ObservedObject var favoritePlacesVM: FavoritePlaceInProfileViewModel

  // navigation stack
  @Binding var rootTabViewIdx: Int
  @Environment(\.dismiss) var dismiss
  @State var path: [StackViewType] = []
  
  // user info
  var userId: Int = -1
  var nickname: String = ""
  var profileUrl: String = ""
  var isFollowing: Bool = false

  var isMyProfile: Bool {
    profileVM.userID == MyData.userID
  }

  init(_ rootTabViewIdx: Binding<Int>) {
    self._rootTabViewIdx = rootTabViewIdx
    self.bookmarkedJournalsVM = JournalsInProfileViewModel(isMyProfile: true,
                                                           userId: MyData.userID)
    self.favoritePlacesVM = FavoritePlaceInProfileViewModel(isMyProfile: true,
                                                           userId: MyData.userID)
  }

  init(userId: Int, nickname: String, profileUrl: String, isFollowing: Bool) {
    self._rootTabViewIdx = .constant(3)
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.isFollowing = isFollowing
    self.bookmarkedJournalsVM = JournalsInProfileViewModel(isMyProfile: false,
                                                           userId: userId)
    self.favoritePlacesVM = FavoritePlaceInProfileViewModel(isMyProfile: false,
                                                           userId: userId)
  }

  // MARK: Body

  var body: some View {
    NavigationStack(path: $path) {
      ScrollView(.vertical) {
        // 네비게이션 바, 프로필 이미지, 닉네임, 팔로우카운트
        VStack(spacing: 24) {
          topNavigationBar
          Group {
            profileImgAndNickname
            followTotal
          }.padding(.horizontal, GridLayout.side)
        }
        // blur처리된 배경화면
        .background(
          BackgroundImageView(imageUrl: profileVM.potdList.first?.imageUrl ?? nil)
            .offset(y: -70)
        )

        VStack(spacing: 20) {
          // 오댜 카운트
          odyaCounter
            .padding(.horizontal, GridLayout.side)

          // 인생샷
          VStack(spacing: 36) {
            POTDTitle
              .padding(.horizontal, GridLayout.side)
            POTDListView($profileVM.potdList, isMyPOTD: isMyProfile)
              .padding(.leading, GridLayout.side)
          }

          divider
          
          // 대표 여행일지
          VStack(spacing: 36) {
            mainJournalTitle
            MainJournalCardView()
          }.padding(.horizontal, GridLayout.side)
          
          // 즐겨찾기 여행일지
          VStack(spacing: 36) {
            bookmarkedJournalTitle
              .padding(.horizontal, GridLayout.side)
            BookmarkedJournalListinProfileView(path: $path)
              .environmentObject(bookmarkedJournalsVM)
              .padding(.leading, GridLayout.side)
          }
          
          divider
          
          // 관심장소
          VStack(spacing: 36) {
            favoritePlaceTitle
            FavoritePlaceListView(rootTabViewIdx: $rootTabViewIdx)
              .environmentObject(favoritePlacesVM)
          }.padding(.horizontal, GridLayout.side)

          // 내 커뮤니티 활동으로 가기
          if isMyProfile {
            divider
            linkToMyCommunity
              .padding(.horizontal, GridLayout.side)
          }
            
        }
        .padding(.top, 20)
        .padding(.bottom, 50)
      }
      .background(Color.odya.background.normal)
      .onAppear {
        if userId > 0 {
          profileVM.initData(userId, nickname, profileUrl)
        }
        // 잘못된 유저 아이디인 경우, 유저 데이터 다시 받아오기
        else {
          let myData = MyData()
          profileVM.initData(
            MyData.userID, myData.nickname, myData.profile.decodeToProileData().profileUrl)
        }

        // 프로필 뷰에서 필요한 데이터 받아오기
        Task {
          await profileVM.fetchDataAsync()
        }
      }
      // stackViewType에 따라 이동할 목적지 뷰
      .navigationDestination(for: StackViewType.self) { stackViewType in
        switch stackViewType {
        case .settingView:
          SettingView().navigationBarBackButtonHidden()
        case .followHubView:
          isMyProfile ? FollowHubView().navigationBarBackButtonHidden() : FollowHubView(userId: userId).navigationBarBackButtonHidden()
        case .potoRegisterView:
          POTDPickerView().navigationBarBackButtonHidden()
        case .mainJournalRegisterView:
          Text("main journal register")
        case .journalDetail(let journalId, let nickname):
          TravelJournalDetailView(journalId: journalId, nickname: nickname)
            .navigationBarBackButtonHidden()
        case .myCommunity:
          MyCommunityActivityView()
        }
      } // navigation destination
    }
  }
}

// MARK: Navigation Bar
extension ProfileView {
  private var topNavigationBar: some View {
    HStack(spacing: 0) {
      if isMyProfile {
        Spacer()
        IconButton("setting") {
          path.append(.settingView)
        }.padding(4)
      } else {
        IconButton("direction-left") {
          dismiss()
        }
        Spacer()
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
  }
}

extension ProfileView {
  // MARK: Section Title
  func getSectionTitleView(title: String,
                           buttonImage: String = "",
                           destinationView: StackViewType? = nil) -> some View {
    HStack {
      Text(title)
        .h4Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      CustomIconButton(buttonImage,
                       color: isMyProfile ? .odya.label.normal : .clear) {
        if let destinationView = destinationView {
          path.append(destinationView)
        }
      }.disabled(!isMyProfile)
    }
  }
  
  // MARK: Section Divider
  private var divider: some View {
    Divider().frame(height: 8).background(Color.odya.blackopacity.baseBlackAlpha70)
  }
}

// MARK: Background Image View
/// 프로필 뷰 배경
/// 인생샷 첫 번째 사진, 인생샷 없을 경우 배경화면도 없음
private struct BackgroundImageView: View {
  let imageUrl: String?
  let size: CGFloat = UIScreen.main.bounds.width
  
  var body: some View {
    if let url = imageUrl {
      AsyncImage(url: URL(string: url)) { image in
        ZStack {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
          Color.odya.blackopacity.baseBlackAlpha50
        }.frame(width: size, height: size)
          .blur(radius: 8)
      } placeholder: {
        defaultBG
      }
    } else {
      defaultBG
    }
  }

  /// 기본 배경, 비어있음
  /// 인생샷이 없을 경우, 인생샷 이미지 불러오는 동안 사용됨
  private var defaultBG: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(.constant(3))
  }
}
