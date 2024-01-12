//
//  MyJournalCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/01.
//

import SwiftUI

// MARK: Random Journal Card View

/// 내 추억 뷰에서 내 여행일지 중 하나를 랜덤으로 보여주기 위한 가장 큰 크기의 카드 뷰
struct RandomJounalCardView: View {
  let cardHeight: CGFloat = 475
  let cardWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)

  var journal: TravelJournalData?
  var title: String { journal?.title ?? "" }
  var travelDateString: String {
    guard let journal = journal else {
      return ""
    }
    return
      "\(journal.travelStartDate.dateToString(format: "yyyy.MM.dd")) ~ \(journal.travelEndDate.dateToString(format: "yyyy.MM.dd"))"
  }
  var locationString: String { "해운대 해수욕장" }
  var imageUrl: String { journal?.imageUrl ?? "" }

  var body: some View {
    ZStack {
      shadowBox.offset(y: -30)
      shadowBox.offset(y: -20)

      // main content
      if journal != nil {
        AsyncImageView(
          url: imageUrl, width: cardWidth, height: cardHeight, cornerRadius: Radius.large)

        VStack {
          Spacer()
          journalInfo
        }
      } else {
        defaultCardView
      }
    }
  }

  private var defaultCardView: some View {
    RoundedRectangle(cornerRadius: Radius.large)
      .frame(width: cardWidth, height: cardHeight)
      .foregroundColor(.odya.elevation.elev2)
      .overlay {
        //        ProgressView()
        //          .frame(width: cardWidth, height: cardHeight)
        Image("logo-lightgray")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: cardWidth / 2)

      }
  }

  private var shadowBox: some View {
    RoundedRectangle(cornerRadius: Radius.large)
      .foregroundColor(Color.odya.whiteopacity.baseWhiteAlpha20)
      .frame(height: cardHeight)
  }

  private var journalInfo: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .b1Style()
          .lineLimit(1)
          .frame(height: 13)
          .padding(.bottom, 12)
        Text(travelDateString)
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 9)
          .padding(.bottom, 16)
        HStack {
          Image("location-s")
          Text(locationString)
            .detail2Style()
        }
      }.foregroundColor(.odya.label.normal)
      Spacer()
    }
    .frame(height: 66)
    .padding(20)
    .background(Color.odya.background.dimmed_system)
    .cornerRadius(Radius.large)
  }
}

// MARK: Travel Journal Card View

/// 내 추억 뷰에서 내 여행일지를 보여주기 위한 기본 크기의 카드 뷰
struct TravelJournalCardView: View {
  @EnvironmentObject var bookmarkJournalsVM: BookmarkedJournalListViewModel
  @StateObject var bookmarkManager = JournalBookmarkManager()

  let cardHeight: CGFloat = 250
  let cardWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)

  let journalId: Int
  var title: String
  var travelDateString: String
  var locationString: String
  var imageUrl: String
  @State private var isBookmarked: Bool

  init(journal: TravelJournalData) {
    self.journalId = journal.journalId
    self.title = journal.title
    self.travelDateString =
      "\(journal.travelStartDate.dateToString(format: "yyyy.MM.dd")) ~ \(journal.travelEndDate.dateToString(format: "yyyy.MM.dd"))"
    // TODO: location, placeId
    self.locationString = "해운대 해수욕장"
    self.imageUrl = journal.imageUrl
    self.isBookmarked = journal.isBookmarked
  }

  var body: some View {
    ZStack {
      AsyncImageView(
        url: imageUrl, width: cardWidth, height: cardHeight, cornerRadius: Radius.large)

      StarButton(isActive: isBookmarked, isYellowWhenActive: true) {
        bookmarkManager.setBookmarkState(isBookmarked, journalId) { result in
          self.isBookmarked = result
          bookmarkJournalsVM.updateBookmarkedJournals()
        }
      }.offset(x: cardWidth / 2 - 25, y: -(cardHeight / 2 - 25))

      VStack {
        Spacer()
        journalInfo
      }.frame(height: cardHeight)
    }
  }

  private var journalInfo: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .b1Style()
          .lineLimit(1)
          .frame(height: 13)
          .padding(.bottom, 12)
        Text(travelDateString)
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 9)
          .padding(.bottom, 16)
        HStack {
          Image("location-s")
          Text(locationString)
            .detail2Style()
        }
      }.foregroundColor(.odya.label.normal)
      Spacer()
    }
    .frame(height: 66)
    .padding(20)
    .background(Color.odya.background.dimmed_system)
    .cornerRadius(Radius.large)
  }
}

// MARK: Travel Journal Small Card View

/// 내 추억 뷰에서 즐겨찾기된 여행일지와 태그된 여행일지를 보여주기 위한 작은 카드 뷰
struct TravelJournalSmallCardView: View {
  let cardWidth: CGFloat = 141
  //  UIScreen.main.bounds.width / 2.5
  let cardHeight: CGFloat = 224
  //  (UIScreen.main.bounds.width / 2.5) * 1.5

  var title: String
  var dateString: String
  var imageUrl: String
  var writer: Writer

  init(title: String, date: Date, imageUrl: String, writer: Writer) {
    self.title = title
    self.dateString =
      date.dateToString(format: "yyyy.MM.dd")
    self.imageUrl = imageUrl
    self.writer = writer
  }

  var body: some View {
    ZStack {
      AsyncImageView(
        url: imageUrl, width: cardWidth, height: cardHeight, cornerRadius: Radius.large)

      LinearGradient(
        stops: [
          Gradient.Stop(color: .black.opacity(0.5), location: 0.00),
          Gradient.Stop(color: .black.opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 0.55)
      )
      VStack {
        Spacer()
        journalInfo
      }
    }.frame(width: cardWidth, height: cardHeight)
  }

  private var journalInfo: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .b1Style()
        .lineLimit(1)
      HStack {
        ProfileImageView(of: writer.nickname, profileData: writer.profile, size: .XS)
        Spacer()
        Text(dateString)
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
      }
    }
    .foregroundColor(.odya.label.normal)
    .padding(12)
    .frame(width: cardWidth)
    .background(Color.odya.background.dimmed_system)
    .cornerRadius(Radius.large)
  }
}

// MARK: My Review Card View

/// 내 추억 뷰에서 내가 쓴 한줄리뷰를 보여주기 위한 카드 뷰
struct MyReviewCardView: View {
  let placeName: String
  let rating: Int
  let review: String
  let date: String

  init(placeName: String, rating: Int, review: String, date: Date) {
    self.placeName = placeName
    self.rating = Int(floor(Double(rating) / 2.0))
    self.review = review
    self.date = date.dateToString(format: "yyyy.MM.dd")
  }

  var body: some View {
    VStack(spacing: 12) {
      HStack(alignment: .top) {
        VStack(spacing: 8) {
          placeNameText
          HStack(spacing: 8) {
            ratingStars
            dateText
          }
        }
        Spacer()
        Menu {
          Button("수정하기") {}
          Button("삭제하기") {}
        } label: {
          Image("menu-kebob")
        }
      }
      reviewText
    }
    .padding(.top, 16)
    .padding(.bottom, 12)
    .padding(.leading, 12)
    .padding(.trailing, 8)
    .background(Color.odya.elevation.elev2)
    .cornerRadius(Radius.medium)
  }

  private var placeNameText: some View {
    HStack {
      Text(placeName)
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
    }
  }

  private var ratingStars: some View {
    HStack(spacing: 0) {
      ForEach(Array(1...5), id: \.self) { i in
        Image(i <= rating ? "star-yellow" : "star-off")
      }
    }
  }

  private var dateText: some View {
    HStack {
      Text(date)
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
      Spacer()
    }
  }

  private var reviewText: some View {
    HStack {
      Text(review)
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
      Spacer()
    }
  }

}

// MARK: Card Overlay Menu View

/// 즐겨찾기된 여행일지 카드뷰에 오버레이 되는 메뉴 바
struct FavoriteJournalCardOverlayMenuView: View {
  @EnvironmentObject var VM: BookmarkedJournalListViewModel
  @StateObject var bookmarkManager = JournalBookmarkManager()

  let journalId: Int
  @State private var isBookmarked: Bool = true
  
  init(journalId: Int, isBookmarked: Bool) {
    self.journalId = journalId
    self.isBookmarked = isBookmarked
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()
        StarButton(isActive: isBookmarked, isYellowWhenActive: true) {
          bookmarkManager.setBookmarkState(isBookmarked, journalId) { result in
            isBookmarked = result
            VM.updateBookmarkedJournals()
          }
        }
      }.padding(10)
      Spacer()
    }
  }
}

/// 태그된 여행일지 카드뷰에 오버레이 되는 메뉴 바
struct TaggedJournalCardOverlayMenuView: View {
  @EnvironmentObject var VM: TaggedJournalListViewModel
  @EnvironmentObject var bookmarkJournalsVM: BookmarkedJournalListViewModel
  @StateObject var bookmarkManager = JournalBookmarkManager()

  let journalId: Int
  var isMarked: Bool {
    bookmarkJournalsVM.bookmarkedJournals.contains(where: { $0.journalId == journalId })
  }
  @State private var isShowingTaggingDeletionAlert: Bool = false

  var body: some View {
    VStack {
      HStack {
        StarButton(isActive: isMarked, isYellowWhenActive: true) {
          bookmarkManager.setBookmarkState(isMarked, journalId) { _ in
            bookmarkJournalsVM.updateBookmarkedJournals()
          }
        }
        Spacer()
        Menu {
          Button("삭제하기") {
            isShowingTaggingDeletionAlert = true
          }
        } label: {
          Image("menu-kebob")
        }
      }.padding(10)
      Spacer()
    }
    .alert("해당 여행일지의 태그를 삭제하시겠습니까?", isPresented: $isShowingTaggingDeletionAlert) {
      Button("취소") { isShowingTaggingDeletionAlert = false }
      Button("삭제") {
        isShowingTaggingDeletionAlert = false
        VM.deleteTagging(of: journalId) { success in
          if success {
            VM.updateTaggedJournals()
          }
        }
      }
    }  // alert
  }
}

struct MyJournalCardView_Previews: PreviewProvider {
  static var previews: some View {
    MyJournalsView()
  }
}
