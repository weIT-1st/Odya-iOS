//
//  CounterSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import SwiftUI

// MARK: Follow Count
extension ProfileView {
  
  /// 총오댜, 팔로워, 팔로잉 수 오버뷰
  var followTotal: some View {
    NavigationLink(
      destination: isMyProfile
        ? FollowHubView().navigationBarHidden(true)
        : FollowHubView(userId: profileVM.userID).navigationBarHidden(true)
    ) {
      HStack(spacing: 20) {
        Spacer()

        getCountStackView(of: "총오댜", count: profileVM.statistics.odyaCount)

        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)

        getCountStackView(of: "팔로잉", count: profileVM.statistics.followingsCount)

        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)

        getCountStackView(of: "팔로우", count: profileVM.statistics.followersCount)

        Spacer()
      }
      .frame(height: 80)
      .background(Color.odya.whiteopacity.baseWhiteAlpha20)
      .cornerRadius(Radius.large)
      .overlay(
        RoundedRectangle(cornerRadius: Radius.large)
          .inset(by: 0.5)
          .stroke(Color.odya.line.alternative, lineWidth: 1)
      )
    }
  }

  private func getCountStackView(of title: String, count: Int) -> some View {
    VStack {
      Text(title)
        .b1Style().foregroundColor(.odya.label.alternative)
      Text("\(count)")
        .h4Style().foregroundColor(.odya.label.normal)
    }
  }
}

// MARK: Odya Counter
extension ProfileView {
  
  /// 오댜 여행간 곳, 여행일지 카운트 오버뷰
  var odyaCounter: some View {
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
  }
}
