//
//  MyJournalsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/30.
//

import SwiftUI

struct RandomJounalCardView: View {
    let cardHeight: CGFloat = 475
    
    var body: some View {
        ZStack {
            shadowBox.offset(y: -30)
            shadowBox.offset(y: -20)
            
            // main content
            RoundedRectangle(cornerRadius: Radius.large)
                .foregroundColor(.white)
                .frame(height: 475)
            
            VStack {
                Spacer()
                journalInfo
            }
        }.frame(width: .infinity)
    }
    
    private var shadowBox: some View {
        RoundedRectangle(cornerRadius: Radius.large)
            .foregroundColor(Color.odya.whiteopacity.baseWhiteAlpha20)
            .frame(height: cardHeight)
    }
    
    private var journalInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("연우랑 행복했던 부산여행")
                    .b1Style()
                Text("2023.06.01 ~ 2023.06.04")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
                HStack {
                    Image("location-s")
                    Text("해운대 해수욕장")
                        .detail2Style()
                }
            }
            Spacer()
        }
        .frame(width: .infinity, height: 66)
        .padding(20)
        .background(Color.odya.background.dimmed_system)
        .cornerRadius(Radius.large)
    }
}

struct travelJournalCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.large)
            IconButton("star-yellow") {}
                .offset(x: 150, y: -100)
            VStack {
                Spacer()
                journalInfo
            }.frame(width: .infinity, height: 250)
        }
    }
    
    private var journalInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("연우랑 행복했던 부산여행")
                    .b1Style()
                Text("2023.06.01 ~ 2023.06.04")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
                HStack {
                    Image("location-s")
                    Text("해운대 해수욕장")
                        .detail2Style()
                }
            }
            Spacer()
        }
        .frame(width: .infinity, height: 66)
        .padding(20)
        .background(Color.odya.background.dimmed_system)
        .cornerRadius(Radius.large)
    }
}

struct travelJournalSmallCardView: View {
    let cardWidth: CGFloat = 140
    let cardHeight: CGFloat = 224
    
    // TODO: 그라데이션 효과
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radius.large)
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
        }
        .frame(width: cardWidth, height: cardHeight)
    }
    
    private var journalInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("연우랑 행복했던 부산여행")
                .b1Style()
                .lineLimit(1)
            HStack {
                Circle().frame(width: 24, height: 24)
                Spacer()
                Text("2023.05.28")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
            }
        }
        .padding(12)
        .frame(width: cardWidth)
        .background(Color.odya.background.dimmed_system)
        .cornerRadius(Radius.large)
    }
}

struct MyJournalsView: View {
    let nickname: String = "이은재"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 50) {
                HStack {
                    Text("\(nickname)님, \n지난 여행을 다시 볼까요?")
                        .h3Style()
                        .foregroundColor(.odya.label.normal)
                    Spacer()
                    Circle().frame(width: 40, height: 40)
                }.padding(.bottom, 20)
                
                RandomJounalCardView()
                
                myTravelJournalList
                myFavoriteTravelJournalList
                myTaggedTravelJournalList
                myReviewList
            }
            .padding(.horizontal, GridLayout.side)
            .padding(.vertical, 48)
        }.background(Color.odya.background.normal)
    }
    
    private var myTravelJournalList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            ForEach(Array(1...5), id: \.self) { journal in
                travelJournalCardView()
                    .padding(.bottom, 12)
            }
        }
    }
    
    private var myFavoriteTravelJournalList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("즐겨찾는 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(1...5), id: \.self) { journal in
                        travelJournalSmallCardView()
                            .overlay {
                                HStack {
                                    Spacer()
                                    IconButton("star-yellow") {}
                                }
                                .padding(6)
                                .offset(y: -87)
                            }
                    }
                }
            }
            
        }
    }
    
    private var myTaggedTravelJournalList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("태그된 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(1...5), id: \.self) { journal in
                        travelJournalSmallCardView()
                            .overlay {
                                HStack {
                                    IconButton("star-yellow") {}
                                    Spacer()
                                    Menu {
                                        Button("삭제하기") {}
                                    } label: {
                                        Image("menu-kebob")
                                    }
                                }
                                .padding(6)
                                .offset(y: -87)
                            }
                    }
                }
            }
            
        }
    }
    
    private var myReviewList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내가 쓴 한줄 리뷰")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
        }
    }
    
}

struct MyJournalsView_Previews: PreviewProvider {
    static var previews: some View {
        MyJournalsView()
    }
}
