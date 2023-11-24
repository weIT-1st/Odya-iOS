//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI
import Photos

struct ProfileView: View {
  @StateObject var profileVM = ProfileViewModel()
  var isMyProfile: Bool {
    profileVM.userID == MyData.userID
  }
  
  @State private var isShowingUpdateProfileImageAlert: Bool = false
  @State private var isShowingImagePickerSheet: Bool = false
  
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
  @State private var selectedImage: [ImageData] = []
  
  init() {}
  
  init(userId: Int, nickname: String, profile: ProfileData) {
    profileVM.userID = userId
    profileVM.nickname = nickname
    profileVM.profileData = profile
  }

  // MARK: Body
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        VStack(spacing: 24) {
          topNavigationBar
          profileImgAndNickname
          followTotal
        }
        .padding(.horizontal, GridLayout.side)
        .background(
          bgImage.offset(y: -70)
        )
        
        odyaCounter
        
        Spacer()
        
        
      }.background(Color.odya.background.normal)
    }
    .onAppear {
      Task {
        await profileVM.fetchDataAsync()
      }
    }
  }
  
  // MARK: Profile
  
  private var topNavigationBar: some View {
    HStack(spacing: 8) {
      Spacer()
      if isMyProfile {
        NavigationLink(
          destination: SettingView()
            .navigationBarHidden(true)
        ) {
          Image("setting")
            .padding(10)
        }
      } else {
        CustomNavigationBar(title: "")
      }
    }
  }
  
  private var profileImgAndNickname: some View {
    VStack(spacing: 24) {
      ZStack {
        ProfileImageView(of: profileVM.nickname, profileData: profileVM.profileData, size: .XL)
        
        if isMyProfile {
          IconButton("camera") {
            isShowingUpdateProfileImageAlert = true
          }
          .background(Color.odya.label.inactive)
          .cornerRadius(50)
          .offset(x: ComponentSizeType.XL.ProfileImageSize / 2 - 15, y: ComponentSizeType.XL.ProfileImageSize / 2 - 15)
        }
      }
       
      HStack(spacing: 12) {
        Text(profileVM.nickname)
          .h3Style()
        if !isMyProfile {
          FollowButton(isFollowing: true, buttonStyle: .solid) {}
        }
      }
    }
    .confirmationDialog("", isPresented: $isShowingUpdateProfileImageAlert) {
      Button("앨범에서 사진 선택") {
        isShowingUpdateProfileImageAlert = false
        isShowingImagePickerSheet = true
      }
      Button("기본 이미지로 변경") {
        isShowingUpdateProfileImageAlert = false
        // api with Null
      }
      Button("취소", role: .cancel) { print("취소 클릭") }
    }
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $selectedImage, maxImageCount: 1, accessStatus: imageAccessStatus)
    }
    .onChange(of: selectedImage) { newValue in
      if newValue.count == 1 {
        print("get new profile image")
        // api with UIImage
        selectedImage = []
      }
    }
  }
  
  private var bgImage: some View {
    Rectangle()
      .foregroundColor(.clear)
      .background(.black.opacity(0.5))
      .background(
        Color.odya.brand.primary
      )
      .blur(radius: 8)
  }
  
  // MARK: Follow
  
  private var followTotal: some View {
    NavigationLink(
      destination: FollowHubView()
        .navigationBarHidden(true)
    ) {
      HStack(spacing: 20) {
        Spacer()
        VStack {
          Text("총오댜")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.odyaCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        VStack {
          Text("팔로잉")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.followingsCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        VStack {
          Text("팔로우")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.followersCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Spacer()
      }
      .frame(height: 80)
      .background(Color.odya.whiteopacity.baseWhiteAlpha20)
      .cornerRadius(Radius.large)
      .overlay (
        RoundedRectangle(cornerRadius: Radius.large)
          .inset(by: 0.5)
          .stroke(Color.odya.line.alternative, lineWidth: 1)
      )
    }
  }
  
  // MARK: Odya Counter
  private var odyaCounter: some View {
    VStack(spacing: 28) {
      Image("odya")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 70)
        .frame(maxWidth: .infinity)
      
      VStack {
        HStack(spacing: 0) {
          Text("\(profileVM.nickname)님은 ")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Text("\(profileVM.statistics.travelPlaceCount)곳을 ")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
          Text("여행하고,")
            .b1Style()
            .foregroundColor(.odya.label.normal)
        }
        HStack(spacing: 0) {
          Text("총 ")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Text("\(profileVM.statistics.travelJournalCount)개의 ")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
          Text("여행일지를 작성했어요!")
            .b1Style()
            .foregroundColor(.odya.label.normal)
        }.padding(.bottom)
      }.multilineTextAlignment(.center)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 24)
    .background(Color.odya.elevation.elev3)
    .cornerRadius(Radius.large)
    .padding(.horizontal, GridLayout.side)
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
