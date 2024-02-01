//
//  FeedNotificationView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/01.
//

import SwiftUI

struct FeedNotificationView: View {
  @StateObject private var viewModel = FeedNotificationViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(title: "알림")
      ScrollView(.vertical) {
        LazyVStack(spacing: 20) {
          ForEach(viewModel.dummyData, id: \.id) { noti in
            // TODO: Navigation Link
            notificationContentCell(content: noti)
            Divider()
          }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, GridLayout.side)
      }
    }
    .onAppear {
      viewModel.getDummy()
      viewModel.getDummy()
    }
    .toolbar(.hidden)
  }
  
  // cell
  private func notificationContentCell(content: TestNotification) -> some View {
    HStack(alignment: .top, spacing: 10) {
      // profile
      ProfileImageView(of: "", profileData: content.profileData, size: .S)
      // content
      switch content.eventType {
      case .followingCommunity:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("를 작성했습니다"))
      case .followingTravelJournal:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("를 작성했습니다"))
      case .travelJournalTag:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("에서 회원님을 태그했습니다"))
      case .communityComment:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("을 남겼습니다 : \(content.commentContent ?? "")"))
      case .communityLike:
        (boldText(content.userName) + regularText(" 님께 ") + coloredText(content.emphasizedWord) + regularText("를 받았습니다"))
      case .followerAdd:
        (boldText(content.userName) + regularText(" 님이 회원님을 ") + coloredText(content.emphasizedWord) + regularText("했습니다"))
      }
      Spacer()
      // image
      AsyncImage(url: URL(string: content.contentImage)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 50, height: 50)
          .clipped()
      } placeholder: {
        ProgressView()
          .frame(width: 50, height: 50)
      }
    }
  }
  
  private func boldText(_ text: String) -> Text {
    let b1 = LogoFontStyle(size: 16, weight: .bold, lineHeight: 1.7)
    return Text(text.splitCharacter())
      .foregroundColor(.odya.label.normal)
      .font(Font.notoSansKRStyle(b1))
  }
  
  private func regularText(_ text: String) -> Text {
    let b2 = LogoFontStyle(size: 16, weight: .regular, lineHeight: 1.7)
    return Text(text.splitCharacter())
      .foregroundColor(.odya.label.normal)
      .font(Font.notoSansKRStyle(b2))
  }
  
  private func coloredText(_ text: String) -> Text {
    let b1 = LogoFontStyle(size: 16, weight: .bold, lineHeight: 1.7)
    return Text(text.splitCharacter())
      .foregroundColor(.odya.brand.primary)
      .font(Font.notoSansKRStyle(b1))
  }
}

// MARK: - Previews
struct FeedNotificationView_Previews: PreviewProvider {
  static var previews: some View {
    FeedNotificationView()
  }
}