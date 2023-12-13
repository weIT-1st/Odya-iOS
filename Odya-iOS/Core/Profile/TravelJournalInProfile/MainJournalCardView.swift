//
//  MainJournalCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct MainJournalCardView: View {
  let totalWidth: CGFloat = UIScreen.main.bounds.width - (GridLayout.side * 2)
  let shadowBoxWidth: CGFloat = 16
  var cardWidth: CGFloat { totalWidth - (shadowBoxWidth * 2) }
  let cardHeight: CGFloat = 280
  let mates: [TravelMate] = [TravelMate(userId: 1, nickname: "hhh", profileUrl: "", isRegistered: true, isFollowing: true),
                             TravelMate(userId: 2, nickname: "kkk", profileUrl: "", isRegistered: true, isFollowing: true),
                             TravelMate(userId: 3, nickname: "jjj", profileUrl: "", isRegistered: true, isFollowing: true)]
  
  var body: some View {
    VStack(spacing: 20) {
      ZStack(alignment: .leading) {
        shadowBox
          .offset(x: 16)
        shadowBox
          .offset(x: 32)
        HStack {
          Rectangle()
            .frame(width: cardWidth, height: cardHeight)
            .foregroundColor(.odya.brand.primary)
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
                journalTitle
                  .offset(x: -5)
                journalDate
                Spacer()
                travelMates
              }
              .padding(.horizontal, GridLayout.side)
              .padding(.top, 26)
              .padding(.bottom, 16)
              .frame(width: cardWidth)
            }
          Spacer()
        }
        
      } // ZStack
      .frame(width: totalWidth)
      
      ZStack {
        RoundedRectangle(cornerRadius: Radius.large)
          .foregroundColor(.odya.elevation.elev4)
          .frame(width: totalWidth, height: 100, alignment: .top)
        HStack(alignment: .top, spacing: 10) {
          Image("pen-s")
            .renderingMode(.template)
          Text("형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.")
            .detail2Style()
            .frame(width: totalWidth - 50, height: 100 - 30, alignment: .topLeading)
        }.foregroundColor(.odya.label.assistive)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 16)
      .frame(width: totalWidth, height: 100)
    }
  }
  
  private var journalTitle: some View {
    Text("ㅇㅇ이랑 행복했던 부산여행")
      .h6Style()
      .foregroundColor(.odya.label.normal)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var journalDate: some View {
    Text("06.01 ~ 06.04")
      .detail2Style()
      .foregroundColor(.odya.label.assistive)
  }
  
  private var travelMates: some View {
    HStack(spacing: 0) {
      let displayedMates = mates.filter({ $0.isRegistered }).prefix(2)
      ForEach(Array(displayedMates.enumerated()), id: \.element.id) { index, mate in
        if let url = mate.profileUrl {
          ProfileImageView(profileUrl: url, size: .S)
            .offset(x: index == 1 ? -8 : 0)
        }
      }

      if mates.count > 2 {
        Text("더보기")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          .offset(x: -8)
      }
    }
  }
  
  private var shadowBox: some View {
    RoundedRectangle(cornerRadius: Radius.large)
      .foregroundColor(Color.odya.whiteopacity.baseWhiteAlpha20)
      .frame(width: cardWidth, height: cardHeight)
  }
}


struct MainJournalCardView_Previews: PreviewProvider {
  static var previews: some View {
    MainJournalCardView()
  }
}

