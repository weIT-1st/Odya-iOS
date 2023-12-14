//
//  MyCommunityActivityView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/14.
//

import SwiftUI

enum MyCommunityActivityOptions: String, CaseIterable {
  case feed = "게시글"
  case like = "좋아요"
  case comment = "댓글"
}

struct MyCommunityActivityView: View {
  // MARK: Properties
  @StateObject private var viewModel = MyCommunityActivityViewModel()
  @State private var selectedOption: MyCommunityActivityOptions = .feed
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(title: "내 활동")
      VStack(spacing: 20) {
        description
        fishchips
      }
      .padding(.horizontal, GridLayout.side)
    }
    .background(Color.odya.background.normal)
  }
  
  private var description: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("\(MyData().nickname)")
          .b1Style()
          .foregroundColor(.odya.brand.primary)
        Text(" 님의 모든 활동을")
          .b1Style()
          .foregroundColor(.odya.label.normal)
      }
      Text("한곳에서 관리해보세요")
        .b1Style()
        .foregroundColor(.odya.label.normal)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 27)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(16)
  }
  
  private var fishchips: some View {
    HStack(spacing: 10) {
      ForEach(MyCommunityActivityOptions.allCases, id: \.self) { option in
        FishchipButton(isActive: .active, buttonStyle: selectedOption == option ? .solid : .ghost, imageName: nil, labelText: option.rawValue, labelSize: .S) {
          // action
          selectedOption = option
        }
      }
      Spacer()
    }
  }
}

// MARK: - Previews
struct MyCommunityActivityView_Previews: PreviewProvider {
  static var previews: some View {
    MyCommunityActivityView()
  }
}
