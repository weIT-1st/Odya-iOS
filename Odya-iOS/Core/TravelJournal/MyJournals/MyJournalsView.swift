//
//  MyJournalsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/30.
//

import SwiftUI

/// 내 추억 뷰
struct MyJournalsView: View {
    let nickname: String = "이은재"
    @State var isOn: Bool = true
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 50) {
                        HStack {
                            Text("\(nickname)님, \n지난 여행을 다시 볼까요?")
                                .h3Style()
                                .foregroundColor(.odya.label.normal)
                            Spacer()
                            Circle().frame(width: 40, height: 40)
                        }.padding(.bottom, 20)
                        
                        NavigationLink(destination: TravelJournalDetailView().navigationBarHidden(true)) {
                            RandomJounalCardView(title: "연우와 행복했던 부산여행", startDate: "2023-06-01".toDate(format: "yyyy-MM-dd")!, endDate: "2023-06-04".toDate(format: "yyyy-MM-dd")!)
                        }
                        
                        myTravelJournalList
                        myFavoriteTravelJournalList
                        myTaggedTravelJournalList
                        myReviewList
                    }
                    .padding(.horizontal, GridLayout.side)
                    .padding(.vertical, 48)
                }
                
                WriteButton() {}
                    .offset(x: -(GridLayout.side), y: -(GridLayout.side))
            }.background(Color.odya.background.normal)
        }
    }
    
    // MARK: My Travel Journal List
    
    private var myTravelJournalList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            ForEach(Array(1...5), id: \.self) { journal in
                NavigationLink(destination: TravelJournalDetailView().navigationBarHidden(true)) {
                    TravelJournalCardView(title: "이번 해에 두 번째 방문하는 돼지런한 서울 여행", startDate: "2023-06-01".toDate(format: "yyyy-MM-dd")!, endDate: "2023-06-04".toDate(format: "yyyy-MM-dd")!)
                }.padding(.bottom, 12)
            }
        }
    }
    
    // MARK: My Favorite Travel Journal List
    
    private var myFavoriteTravelJournalList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("즐겨찾는 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(1...5), id: \.self) { journal in
                        NavigationLink(destination: TravelJournalDetailView().navigationBarHidden(true)) {
                            TravelJournalSmallCardView(title: "ㅇㅇ이랑 행복했던 경주여행", date: "2023.05.28".toDate(format: "yyyy-MM-dd")!)
                        }.overlay {
                            FavoriteJournalCardOverlayMenuView()
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: My Tagged Travel Journal List
    
    private var myTaggedTravelJournalList: some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text("태그된 여행일지")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(1...5), id: \.self) { journal in
                        NavigationLink(destination: TravelJournalDetailView().navigationBarHidden(true)) {
                            TravelJournalSmallCardView(title: "ㅇㅇ이랑 행복했던 경주여행", date: "2023.05.28".toDate(format: "yyyy-MM-dd")!)
                        }
                        .overlay {
                            TaggedJournalCardOverlayMenuView()
                        }
                    }
                }
            }
            
        }
    }
    
    // MARK: My Review List
    
    private var myReviewList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내가 쓴 한줄 리뷰")
                .h4Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 32)
            
            ForEach(Array(1...5), id: \.self) { journal in
                MyReviewCardView(placeName: "해운대 해수욕장", rating: 7, review: "노을뷰가 너무 예뻐요~ 노을뷰가 너무 예뻐요~ 노을뷰가 너무 예뻐요~", date: "2023-08-01".toDate(format: "yyyy-MM-dd")!)
                    .padding(.bottom, 12)
            }
        }
    }
    
}

struct MyJournalsView_Previews: PreviewProvider {
    static var previews: some View {
        MyJournalsView()
    }
}
