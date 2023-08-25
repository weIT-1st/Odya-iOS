//
//  TravelMateSelectorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

struct ProfileColorData: Codable {
    var colorHex: String?
}

struct ProfileData: Codable {
    var profileUrl: String?
    var profileColor: ProfileColorData
}

struct FollowUserData: Codable, Identifiable, Hashable {
    var id = UUID()
    var userId: Int
    var nickname: String
    var profileData: ProfileData
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FollowUserData: Equatable {
    static func == (lhs: FollowUserData, rhs: FollowUserData) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func != (lhs: FollowUserData, rhs: FollowUserData) -> Bool {
        return !(lhs == rhs)
    }
}

struct SelectedMateView: View {
    private let mateUserData: FollowUserData
    private let status: ProfileImageStatus
    
    init(mate: FollowUserData) {
        self.mateUserData = mate
        if let profileUrl = mate.profileData.profileUrl {
            self.status = .withImage(url: URL(string: profileUrl)!)
        } else {
            self.status = .withoutImage(colorHex: mate.profileData.profileColor.colorHex ?? "#FFD41F", name: mate.nickname)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                ProfileImageView(status: status, sizeType: .L)
                    .padding(.top, 16)
                Image("smallGreyButton-x-filled")
                    .offset(x: 27.5, y: -55)
                    .frame(width: 0, height: 0)
            }
            Text(mateUserData.nickname)
                .detail2Style()
                .foregroundColor(.odya.label.normal)
                .lineLimit(1)
        }
        .frame(width: ComponentSizeType.L.ProfileImageSize)
    }
}

struct FollowUserView: View {
    let userData: FollowUserData
    private let status: ProfileImageStatus
    
    init(user: FollowUserData) {
        self.userData = user
        if let profileUrl = user.profileData.profileUrl {
            self.status = .withImage(url: URL(string: profileUrl)!)
        } else {
            self.status = .withoutImage(colorHex: user.profileData.profileColor.colorHex ?? "#FFD41F", name: user.nickname)
        }
    }
    
    var body: some View {
        NavigationLink(destination: UserProfileView(userData: userData)) {
            HStack(spacing: 0) {
                ProfileImageView(status: status, sizeType: .S)
                    .padding(.trailing, 12)
                Text(userData.nickname)
                    .foregroundColor(.odya.label.normal)
                    .b1Style()
                    .padding(.trailing, 4)
                Image("sparkle-s")
            }
        }
    }
}

struct UserProfileView: View {
    let userData: FollowUserData
    
    var body: some View {
        Text(userData.nickname)
    }
}

struct TravelMateSelectorView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var travelJournalEditVM: TravelJournalEditViewModel
    
    @State var selectedTravelMates: [FollowUserData] = []
    @State var followingUsers: [FollowUserData] = []
    @State var displayedFollowingUsers: [FollowUserData] = []
    
    @State var nameToSearch: String = ""
    
    @State var isShowingTooManyMatesAlert: Bool = false
    
    @State var selectedMatesViewHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            headerBar
            selectedMatesView
            
            VStack(spacing: 16) {
                followingUserSearchBar
                followingUserListView
            }
            .padding(.top, 34)
            .background(Color.odya.elevation.elev2)
            
        }.background(Color.odya.background.normal)
        .onAppear {
            selectedTravelMates = travelJournalEditVM.travelMates
            // test user
            for i in 0...10 {
                let user = FollowUserData(userId: i, nickname: "홍길동aa\(i)", profileData: ProfileData(profileColor: ProfileColorData(colorHex: "#FFD41F")))
                followingUsers.append(user)
                displayedFollowingUsers.append(user)
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
    
    private var followingUserSearchBar: some View {
        HStack {
            TextField(nameToSearch, text: $nameToSearch,
                      prompt: Text("닉네임 검색")
                .foregroundColor(.odya.label.inactive))
            .b1Style()
            
            IconButton("search") {}
                .disabled(nameToSearch.count == 0)
        }
        .modifier(CustomFieldStyle(backgroundColor: Color.odya.elevation.elev4))
        .padding(.horizontal, GridLayout.side)
        .onChange(of: nameToSearch) { newValue in
            if nameToSearch.count == 0 {
                displayedFollowingUsers = followingUsers
            } else {
                displayedFollowingUsers = followingUsers.filter{ $0.nickname.contains(newValue) }
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
                        .colorMultiply(selectedTravelMates.contains{ mate in
                            mate.userId == user.userId
                        } ? .odya.label.inactive : .odya.brand.primary)
                        .frame(height: 36)
                        .disabled(selectedTravelMates.contains { mate in
                            mate.userId == user.userId
                        })
                    }.frame(height: 36)
                }
            }.padding(.horizontal, GridLayout.side)
        }.edgesIgnoringSafeArea(.bottom)
    }

}

struct TravelMateSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        TravelMateSelectorView(travelJournalEditVM: TravelJournalEditViewModel())
    }
}
