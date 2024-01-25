//
//  LocationSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

struct LocationSearchView: View {
  // MARK: - Properties
  @EnvironmentObject var placeInfo: PlaceInfo
  /// 장소 검색 뷰모델
  @StateObject var searchVM = LocationSearchViewModel()
  /// 랭킹 뷰모델
  @StateObject var rankVM = RankViewModel()
  /// 현재 뷰 토글
  @Binding var isPresented: Bool
  /// 장소 상세보기 뷰 토글
  @Binding var showPlaceDetail: Bool
  /// 랭킹 그리드 칼럼
  let rankColumns = Array(repeating: GridItem(.flexible(minimum: 36), spacing: 0), count: 5)
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 0) {
      searchBar
        .padding(.horizontal, GridLayout.side)
        .padding(.bottom, 26)
      
      // Show recent searches if search query is empty
      if searchVM.queryFragment.isEmpty {
        VStack(spacing: 0) {
          recentSearchHeader
          // 검색어 리스트 출력
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
              ForEach(searchVM.recentSearchTexts.reversed(), id: \.self) { text in
                RecentSearchCell(searchText: text)
                  .environmentObject(searchVM)
              }
            }
            .padding(.vertical, 12)
          }
        }
        .padding(.horizontal, GridLayout.side)
        
        darkDivider
        // 랭킹
        rankingHeader
        rankingGrid
      } else {
        // 검색 자동완성 결과 출력
        ScrollView(.vertical, showsIndicators: false) {
          VStack(alignment: .leading, spacing: 11) {
            ForEach(searchVM.searchResults, id: \.self) { result in
              let title = result.attributedPrimaryText.string
              let subtitle = result.attributedSecondaryText?.string ?? ""
              Button {
                searchVM.savePlaceSearchHistory()
                placeInfo.setValue(title: title, address: subtitle, placeId: result.placeID, token: searchVM.placeToken)
                isPresented = false
                withAnimation {
                  showPlaceDetail = true
                }
              } label: {
                LocationSearchResultCell(title: title, subtitle: subtitle)
              }
              if result != searchVM.searchResults.last {
                Divider()
              }
            }
          }
        } // ScrollView
        .padding(.horizontal, GridLayout.side)
      } // if-else
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 24)
    .background(Color.odya.elevation.elev3)
    .task {
      rankVM.fetchEntireRanking()
    }
  }
  
  /// 장소검색바
  private var searchBar: some View {
    HStack(spacing: 13) {
      HStack {
        TextField("", text: $searchVM.queryFragment)
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .placeholder(when: searchVM.queryFragment.isEmpty) {
            Text("⚡️ 어디에 가고싶으신가요?")
              .b2Style()
              .foregroundColor(.odya.label.assistive)
          }
          .submitLabel(.search)
          .onSubmit {
            searchVM.appendRecentSearch()
            searchVM.savePlaceSearchHistory()
          }
        
        Spacer()
        
        if searchVM.queryFragment.isEmpty {
          Image("search")
            .renderingMode(.template)
            .foregroundColor(.odya.label.assistive)
            .frame(width: 36, height: 36)
        } else {
          Button {
            searchVM.queryFragment = ""
          } label: {
            Image("smallGreyButton-x-filled-elv5")
              .frame(width: 36, height: 36)
          }
        }
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 1)
      .background(Color.odya.elevation.elev6)
      .cornerRadius(Radius.medium)
      
      Button {
        isPresented = false
        searchVM.queryFragment = ""
      } label: {
        Text("취소")
          .b2Style()
          .foregroundColor(.odya.label.normal)
          .padding(10)
      }
    }
  }
  
  /// 최근 검색 상단 헤더
  private var recentSearchHeader: some View {
    HStack(alignment: .center) {
      Text("최근검색")
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      Button {
        // action: 검색어 모두 삭제
        searchVM.removeAllRecentSearch()
      } label: {
        Text("모두삭제")
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
      }
    }
    .padding(.horizontal, 8)
  }
  
  /// Divider
  private var darkDivider: some View {
    Rectangle()
      .foregroundColor(.odya.background.dimmed_dark)
      .frame(height: 8)
      .frame(maxWidth: .infinity)
  }
  
  /// 랭킹 헤더
  private var rankingHeader: some View {
    HStack(alignment: .center) {
      Text("🔥 오댜 핫플")
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      Text("\(Date().dateToString(format: "MM.dd HH:mm")) 기준")
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
    }
    .padding(.leading, 25)
    .padding(.trailing, 21)
    .padding(.top, 24)
    .padding(.bottom, 16)
  }
  
  /// 랭킹 그리드 셀 최대 너비
  private let maxGridWidth = UIScreen.main.bounds.width - 12 - GridLayout.side * 2
  /// 랭킹 표시 그리드
  private var rankingGrid: some View {
    LazyHGrid(rows: rankColumns, spacing: 12) {
      ForEach(0..<rankVM.rankingList.count, id: \.self) { index in
        RankCell(index: index, title: rankVM.rankingList[index])
          .frame(minWidth: rankVM.rankingList.count > 5 ? maxGridWidth / 2 : maxGridWidth,
                 maxWidth: rankVM.rankingList.count > 5 ? maxGridWidth / 2 : maxGridWidth)
      }
    }
    .padding(.horizontal, GridLayout.side)
  }
}

// MARK: - Previews
struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(isPresented: .constant(true), showPlaceDetail: .constant(false))
  }
}
