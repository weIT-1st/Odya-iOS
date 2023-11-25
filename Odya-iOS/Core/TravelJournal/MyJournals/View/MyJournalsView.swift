//
//  MyJournalsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/30.
//

import SwiftUI

/// 내 추억 뷰
struct MyJournalsView: View {

  @StateObject var VM = MyJournalsViewModel()

  // TODO: 즐겨찾기
  @State private var isOn: Bool = true

  // MARK: Body

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        Color.odya.background.normal
          .ignoresSafeArea()
        
        if VM.isMyJournalsLoading {
          ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(alignment: .center)
        }
        
        else if VM.myJournals.isEmpty {
          NoJournalView()
        }
        
        else {
          ScrollView(showsIndicators: false) {
            VStack(spacing: 50) {
              headerBar
              
              randomMainBoard
              
              myTravelJournalList
              
              if VM.isBookmarkedJournalsLoading
                  || !VM.bookmarkedJournals.isEmpty {
                myBookmarkedTravelJournalList
              }
              
              if VM.isTaggedJournalsLoading
                  || !VM.taggedJournals.isEmpty {
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
      }  // ZStack
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

    }  // Navigation View
  }

  private var headerBar: some View {
    HStack {
      Text("\(VM.nickname)님, \n지난 여행을 다시 볼까요?")
        .h3Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      ProfileImageView(of: VM.nickname, profileData: VM.profile, size: .M)
    }.padding(.bottom, 20)
  }

  private var randomMainBoard: some View {
    VStack(spacing: 0) {
      let randomJournal = VM.myJournals.randomElement() ?? VM.myJournals[0]
      NavigationLink(
        destination: TravelJournalDetailView(journalId: randomJournal.journalId)
          .navigationBarHidden(true)
      ) {
        RandomJounalCardView(
          journal: randomJournal)
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
        NavigationLink(
          destination: TravelJournalDetailView(journalId: journal.journalId).navigationBarHidden(
            true)
        ) {
          TravelJournalCardView(journal: journal)
            .environmentObject(VM)
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
      
      ZStack(alignment: .center) {
        if VM.isBookmarkedJournalsLoading {
          ProgressView()
            .frame(height: 250)
            .frame(maxWidth: .infinity)
        }
        
        else {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
              ForEach(VM.bookmarkedJournals, id: \.id) { journal in
                NavigationLink(
                  destination: TravelJournalDetailView(journalId: journal.journalId, nickname: journal.writer.nickname)
                    .navigationBarHidden(true)
                ) {
                  TravelJournalSmallCardView(
                    title: journal.title, date: journal.travelStartDate, imageUrl: journal.mainImageUrl, writer: journal.writer)
                }.overlay {
                  FavoriteJournalCardOverlayMenuView(journalId: journal.journalId)
                    .environmentObject(VM)
                }
              } // ForEach
            }
          } // ScrollView
        }
      } // ZStack

    }
  }

  // MARK: My Tagged Travel Journal List

  private var myTaggedTravelJournalList: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("태그된 여행일지")
        .h4Style()
        .foregroundColor(.odya.label.normal)
        .padding(.bottom, 32)
      
      ZStack(alignment: .center) {
        if VM.isTaggedJournalsLoading {
          ProgressView()
            .frame(height: 250)
            .frame(maxWidth: .infinity)
        }
        
        else {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
              ForEach(VM.taggedJournals, id: \.id) { journal in
                NavigationLink(
                  destination: TravelJournalDetailView(journalId: journal.journalId, nickname: journal.writer.nickname)
                    .navigationBarHidden(true)
                ) {
                  TravelJournalSmallCardView(
                    title: journal.title, date: journal.travelStartDate, imageUrl: journal.mainImageUrl, writer: journal.writer)
                }
                .overlay {
                  TaggedJournalCardOverlayMenuView(journalId: journal.journalId)
                    .environmentObject(VM)
                }
              } // ForEach
            }
          } // ScrollView
        }
      } // ZStack
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
