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
  @StateObject var bookmarkedJournalsVM = BookmarkedJournalListViewModel()
  @StateObject var taggedJournalsVM = TaggedJournalListViewModel()
  
  @State private var isShowingRandomMainJournal: Bool = false
  @State private var isShowingComposeView: Bool = false
  
  var isNoJournals: Bool {
    !VM.isMyJournalsLoading && VM.myJournals.isEmpty
  }
  
  // MARK: Body
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        Color.odya.background.normal
          .ignoresSafeArea()
        
//        if VM.isMyJournalsLoading && VM.myJournals.isEmpty {
//          ProgressView()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
        
        // 작성된 여행일지가 없는 경우
        ScrollView(showsIndicators: false) {
          if isNoJournals {
            NoJournalView()
          }
          
          else {
            
            LazyVStack(spacing: 50) {
              headerBar
                .padding(.horizontal, GridLayout.side)
              randomMainBoard
                .padding(.horizontal, GridLayout.side)
              myTravelJournalList
                .padding(.horizontal, GridLayout.side)
              
              if bookmarkedJournalsVM.isBookmarkedJournalsLoading
                  || !bookmarkedJournalsVM.bookmarkedJournals.isEmpty {
                myBookmarkedTravelJournalList
              }
              
              if taggedJournalsVM.isTaggedJournalsLoading
                  || !taggedJournalsVM.taggedJournals.isEmpty {
                myTaggedTravelJournalList
              }
              
              myReviewList
                .padding(.horizontal, GridLayout.side)
            }
            .padding(.vertical, 50)
            
          }
          
        } // Scroll View
        
        // write button
        if !isNoJournals {
          WriteButtonWithAction(action: { isShowingComposeView = true })
            .offset(x: -(GridLayout.side), y: -(GridLayout.side))
            .fullScreenCover(isPresented: $isShowingComposeView) {
              TravelJournalComposeView()
            }
        }
      } // ZStack
      .task {
        VM.getMyData()
        VM.initData()
        await VM.fetchDataAsync()
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
      let myData = MyData()
      ProfileImageView(of: myData.nickname, profileData: myData.profile.decodeToProileData(), size: .M)
    }.padding(.bottom, 20)
  }
  
  func getSectionTitle(title: String) -> some View {
    Text(title)
      .h4Style()
      .foregroundColor(.odya.label.normal)
      .padding(.bottom, 32)
  }
  
  private var randomMainBoard: some View {
    VStack(spacing: 0) {
      let randomJournal = VM.myJournals.randomElement()
      NavigationLink(
        destination: TravelJournalDetailView(journalId: randomJournal?.journalId ?? -1)
          .navigationBarHidden(true)
      ) {
        RandomJounalCardView(journal: randomJournal)
      }.disabled(randomJournal == nil)
    }
  }
}

// MARK: My Travel Journal List
extension MyJournalsView {
  private var myTravelJournalList: some View {
    LazyVStack(alignment: .leading, spacing: 0) {
      self.getSectionTitle(title: "내 여행일지")
      
      ForEach(VM.myJournals, id: \.id) { journal in
        NavigationLink(
          destination: TravelJournalDetailView(journalId: journal.journalId)
            .navigationBarHidden(true)
        ) {
          TravelJournalCardView(journal: journal)
            .environmentObject(bookmarkedJournalsVM)
        }.padding(.bottom, 12)
          .onAppear {
            if let last = VM.lastIdOfMyJournals,
               last == journal.journalId {
              VM.fetchMoreMyJournalsSubject.send()
            }
          }
      }
    }
  }
}

// MARK: My Favorite Travel Journal List
extension MyJournalsView {
  private var myBookmarkedTravelJournalList: some View {
    VStack(alignment: .leading, spacing: 0) {
      self.getSectionTitle(title: "즐겨찾는 여행일지")
        .padding(.horizontal, GridLayout.side)
      BookmarkedJournalListView()
        .environmentObject(bookmarkedJournalsVM)
        .padding(.leading, GridLayout.side)
    }
  }
}

// MARK: My Tagged Travel Journal List
extension MyJournalsView {
  private var myTaggedTravelJournalList: some View {
    VStack(alignment: .leading, spacing: 0) {
      self.getSectionTitle(title: "태그된 여행일지")
        .padding(.horizontal, GridLayout.side)
      TaggedJournalListView()
        .environmentObject(taggedJournalsVM)
        .environmentObject(bookmarkedJournalsVM)
        .padding(.leading, GridLayout.side)
    }
  }
}

// MARK: My Review List
extension MyJournalsView {
  private var myReviewList: some View {
    VStack(alignment: .leading, spacing: 0) {
      self.getSectionTitle(title: "내가 쓴 한줄 리뷰")

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
