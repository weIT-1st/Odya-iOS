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
          ForEach(viewModel.notificationList, id: \._id) { noti in
            // TODO: Navigation Link
            notificationContentCell(content: noti)
            Divider()
          }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, GridLayout.side)
      }
    }
    .background(Color.odya.background.normal)
    .task {
      viewModel.readSavedNotifications()
    }
    .toolbar(.hidden)
  }
  
  // cell
  private func notificationContentCell(content: NotificationData) -> some View {
    HStack(alignment: .top, spacing: 10) {
      ProfileImageView(profileUrl: content.userProfileUrl ?? "", size: .S)
      // content
      let event = NotificationEventType(rawValue: content.eventType)
      switch event {
      case .followingCommunity:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("를 작성했습니다")) + dateText(content.notifiedAt)
      case .followingTravelJournal:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("를 작성했습니다")) + dateText(content.notifiedAt)
      case .travelJournalTag:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("에서 회원님을 태그했습니다")) + dateText(content.notifiedAt)
      case .communityComment:
        (boldText(content.userName) + regularText(" 님이 ") + coloredText(content.emphasizedWord) + regularText("을 남겼습니다 : \(content.commentContent ?? "")")) + dateText(content.notifiedAt)
      case .communityLike:
        (boldText(content.userName) + regularText(" 님께 ") + coloredText(content.emphasizedWord) + regularText("를 받았습니다")) + dateText(content.notifiedAt)
      case .followerAdd:
        (boldText(content.userName) + regularText(" 님이 회원님을 ") + coloredText(content.emphasizedWord) + regularText("했습니다")) + dateText(content.notifiedAt)
      case .none:
        Spacer()
      }
      Spacer()
      // image
      if let _ = content.contentImage {
        if let contentImage = content.thumbnailImage {
          contentImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipped()
        } else {
          defaultContentImage
        }
      }

//      if let imageUrl = content.contentImage {
//        AsyncImage(url: URL(string: imageUrl)) { image in
//          image
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: 50, height: 50)
//            .clipped()
//        } placeholder: {
//          ProgressView()
//            .frame(width: 50, height: 50)
//        }
//      }
    }
  }
  
  private var defaultContentImage: some View {
    Image("logo-lightgray")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .padding(12)
      .frame(width: 50, height: 50)
      .background(Color.odya.background.dimmed_dark)
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
  
  private func dateText(_ text: String) -> Text {
    let detail2 = LogoFontStyle(size: 12, weight: .regular, lineHeight: 1.5)
    return Text(" ·  \(text.toCustomRelativeDateString())")
      .foregroundColor(.odya.label.assistive)
      .font(Font.notoSansKRStyle(detail2))
  }
}

// MARK: - Previews
struct FeedNotificationView_Previews: PreviewProvider {
  static var previews: some View {
    FeedNotificationView()
  }
}
