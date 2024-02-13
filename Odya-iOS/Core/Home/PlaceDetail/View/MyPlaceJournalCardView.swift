//
//  MyPlaceJournalCardView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/25.
//

import SwiftUI

/// 장소 상세보기 - 나의 여행일지 카드 뷰
struct MyPlaceJournalCardView: View {
  // MARK: Properties
  let totalWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)
  let shadowBoxWidth: CGFloat = 12.87
  var cardWidth: CGFloat { totalWidth - shadowBoxWidth }
  let cardHeight: CGFloat = 280
  
  let myJournal: TravelJournalData
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 12) {
      ZStack(alignment: .leading) {
        shadowBox
          .offset(x: shadowBoxWidth, y: 1)
        HStack {
          cardView
          Spacer()
        }
      }
      .frame(width: totalWidth)
      
      journalContent
    }
  }
  
  // MARK: Card
  private var cardView: some View {
    Rectangle()
      .foregroundColor(.odya.brand.primary)
      .frame(width: cardWidth, height: cardHeight)
      .cornerRadius(Radius.large)
      .overlay {
        LinearGradient(
          stops: [
            Gradient.Stop(color: .black.opacity(0.5), location: 0.09),
            Gradient.Stop(color: .black.opacity(0), location: 1.00),
          ],
          startPoint: UnitPoint(x: 0.5, y: 0),
          endPoint: UnitPoint(x: 0.5, y: 1)
        ).cornerRadius(Radius.large)
      }
      .overlay {
        VStack(alignment: .leading, spacing: 0) {
          VStack(alignment: .leading, spacing: 14) {
            journalTitle
            journalDate
          }
          Spacer()
          travelMates
        }
        .padding(.leading, 23)
        .padding(.trailing, 21)
        .padding(.top, 25)
        .padding(.bottom, 13)
        .frame(width: cardWidth)
      }
  }
  
  private var journalTitle: some View {
    Text(myJournal.title)
      .h6Style()
      .foregroundColor(.odya.label.normal)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var journalDate: some View {
    HStack {
      let startDateString = myJournal.travelStartDate.dateToString(format: "yyyy .MM.dd")
      let endDateString = myJournal.travelEndDate.dateToString(format: "MM.dd")
      Text(startDateString + " ~ " + endDateString)
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }

  private var travelMates: some View {
    HStack(spacing: 0) {
      Spacer()
      HStack(spacing: -8) {
        ForEach(myJournal.travelMates.prefix(2), id: \.id) { mate in
          if let url = mate.profileUrl {
            ProfileImageView(profileUrl: url, size: .S)
          }
        }
      }
      if myJournal.travelMates.count > 2 {
        Text("더보기")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
      }
    }
  }
  
  // MARK: Content
  private var journalContent: some View {
    HStack(alignment: .top, spacing: 12) {
      Image("pen-s")
        .renderingMode(.template)
      Text(myJournal.content ?? "")
        .detail2Style()
        .multilineTextAlignment(.leading)
        .lineLimit(3)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    .foregroundColor(.odya.label.assistive)
    .padding(.vertical, 16)
    .padding(.horizontal, 10)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.large)
  }
  
  // MARK: Shadow
  private var shadowBox: some View {
    AsyncImage(url: URL(string: myJournal.imageUrl)!) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(Radius.large)
        .clipped()
    } placeholder: {
      RoundedRectangle(cornerRadius: Radius.large)
        .foregroundColor(Color.odya.label.inactive)
        .frame(width: cardWidth, height: cardHeight)
    }
  }
}

// MARK: - Previews
struct MyPlaceJournalCardView_Previews: PreviewProvider {
  static var previews: some View {
    MyPlaceJournalCardView(myJournal: TravelJournalData(
      journalId: -1,
      title: "즐거운 여행",
      content: "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.",
      imageUrl: "1234",
      startDateString: "2023-08-01",
      endDateString: "2023-08-05",
      placeIds: [],
      writer: Writer(userID: -1, nickname: "닉네임", profile: ProfileData(profileUrl: ""), isFollowing: false),
      visibility: "PUBLIC",
      travelMates: [travelMateSimple(username: "친구이름")], 
      isBookmarked: false))
  }
}
