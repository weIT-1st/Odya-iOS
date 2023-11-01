//
//  MyJournalsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/30.
//

import SwiftUI


private struct NoJournalView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Image("noJournalImg")
                .resizable()
                .scaledToFit()
            Text("작성된 여행일지가 없어요!")
                .h6Style()
                .foregroundColor(.odya.label.normal)
                .padding(.bottom, 80)
            ZStack {
                CTAButton(
                    isActive: .active, buttonStyle: .solid, labelText: "여행일지 작성하러가기", labelSize: ComponentSizeType.L,
                    action: {})
                
                NavigationLink( destination: TravelJournalComposeView()
                    .navigationBarHidden(true)
                ) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: ComponentSizeType.L.CTAButtonWidth, height: 48)
                }
            }
            
            Spacer()
        }.background(Color.odya.background.normal)
        
    }
    
}


/// 내 추억 뷰
struct MyJournalsView: View {

    @StateObject var VM = MyJournalsViewModel()
  @State private var isOn: Bool = true

  // MARK: Body

  var body: some View {
      NavigationView {
          ZStack(alignment: .bottomTrailing) {
              Color.odya.background.normal
                  .ignoresSafeArea()
              
              if VM.isMyJournalsLoading {
                  ProgressView()
              }
              
              else if VM.myJournals.isEmpty {
                  NoJournalView()
              }
              
              else {
                  ScrollView(showsIndicators: false) {
                      VStack(spacing: 50) {
                          HStack {
                              Text("\(VM.nickname)님, \n지난 여행을 다시 볼까요?")
                                  .h3Style()
                                  .foregroundColor(.odya.label.normal)
                              Spacer()
                              ProfileImageView(of: VM.nickname, profileData: VM.profile, size: .M)
                          }.padding(.bottom, 20)
                          
                          NavigationLink(destination: TravelJournalDetailView(journalId: 1).navigationBarHidden(true)) {
                              RandomJounalCardView(
                                title: VM.myJournals[0].title, startDate: VM.myJournals[0].travelStartDate,
                                endDate: VM.myJournals[0].travelEndDate)
                          }
                          
                          myTravelJournalList
                          
                          if !VM.bookmarkedJournals.isEmpty {
                              myBookmarkedTravelJournalList
                          }
                          if !VM.taggedJournals.isEmpty {
                              myTaggedTravelJournalList
                          }
                          myReviewList
                      }
                      .padding(.horizontal, GridLayout.side)
                      .padding(.vertical, 48)
                  }
                  
                  // write button
                  NavigationLink(destination: TravelJournalComposeView().navigationBarHidden(true)) {
                      WriteButton()
                          .offset(x: -(GridLayout.side), y: -(GridLayout.side))
                  }
              }
          }
      }
      .onAppear {
          VM.getMyData()
          Task {
              VM.initData()
              await VM.fetchDataAsync()
          }
      }
      .refreshable {
          Task {
              VM.initData()
              await VM.fetchDataAsync()
          }
      }

  }

  // MARK: My Travel Journal List

  private var myTravelJournalList: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("내 여행일지")
        .h4Style()
        .foregroundColor(.odya.label.normal)
        .padding(.bottom, 32)

        ForEach(VM.myJournals, id: \.id) { journal in
            NavigationLink(destination: TravelJournalDetailView(journalId: journal.journalId).navigationBarHidden(true)) {
            TravelJournalCardView(journal: journal)
        }.padding(.bottom, 12)
      }
    }
  }

  // MARK: My Favorite Travel Journal List

  private var myBookmarkedTravelJournalList: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("즐겨찾는 여행일지")
        .h4Style()
        .foregroundColor(.odya.label.normal)
        .padding(.bottom, 32)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
                ForEach(VM.bookmarkedJournals, id: \.id) { journal in
                    NavigationLink(destination: TravelJournalDetailView(journalId: journal.journalId).navigationBarHidden(true)) {
              TravelJournalSmallCardView(
                title: journal.title, date: journal.travelStartDate)
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
            ForEach(VM.taggedJournals, id: \.id) { journal in
                NavigationLink(destination: TravelJournalDetailView(journalId: journal.journalId).navigationBarHidden(true)) {
              TravelJournalSmallCardView(
                title: journal.title, date: journal.travelStartDate)
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
        MyReviewCardView(
          placeName: "해운대 해수욕장", rating: 7, review: "노을뷰가 너무 예뻐요~ 노을뷰가 너무 예뻐요~ 노을뷰가 너무 예뻐요~",
          date: "2023-08-01".toDate(format: "yyyy-MM-dd")!
        )
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
