//
//  FeedUserSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/29.
//

import SwiftUI

struct FeedUserSearchView: View {
  // MARK: Properties
  @StateObject private var viewModel = FeedUserSearchViewModel()
  @Binding var isPresented: Bool
  /// 검색할 텍스트
  @State private var searchText: String = ""
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 30) {
      searchBar
      // TODO: 최근검색 or 검색결과
      ScrollView(.vertical, showsIndicators: false) {
        recentSearchLabel

        LazyVStack(spacing: 10) {
          ForEach(viewModel.state.content, id: \.userId) { content in
            FeedUserSearchCell(isSearching: true, content: content)
              .onAppear {
                if viewModel.state.content.last == content {
                  viewModel.searchUserNextPageIfPossible(query: searchText)
                }
              }
          }
        }
      }
    } // VStack
    .padding(GridLayout.side)
    .background(Color.odya.background.normal)
    .onChange(of: searchText) { newValue in
      viewModel.initiateState()
      if !newValue.isEmpty {
        viewModel.searchUserNextPageIfPossible(query: searchText)
      }
    }
  }
  
  /// 검색창
  private var searchBar: some View {
    HStack(spacing: 22) {
      HStack(alignment: .center, spacing: 0) {
        TextField("친구를 찾아보세요!", text: $searchText)
          .b1Style()
          .foregroundColor(.odya.label.normal)
        Spacer()
        if searchText.isEmpty {
          Image("search")
            .renderingMode(.template)
            .foregroundColor(.odya.label.assistive)
            .padding(6)
        } else {
          Button {
            // action: 현재 검색어 지우기
            searchText = ""
          } label: {
            Image("smallGreyButton-x-filled-elv5")
          }
        }
      }
      .padding(10)
      .background(Color.odya.elevation.elev6)
      .frame(height: 38)
      .cornerRadius(Radius.medium)
      // cancel button
      Button {
        isPresented.toggle()
      } label: {
        Text("취소")
          .b1Style()
          .foregroundColor(.odya.label.normal)
      }
    }
  }
  
  /// 최근 검색 레이블
  private var recentSearchLabel: some View {
    HStack {
      Text("최근 검색")
        .b1Style()
        .foregroundColor(.odya.label.assistive)
        .padding(.bottom, 20)
      Spacer()
    }
  }
}

/// FeedUserSearchCell
struct FeedUserSearchCell: View {
  let isSearching: Bool
  let content: SearchedUserContent
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      ProfileImageView(profileUrl: content.profile.profileUrl, size: .S)
      HStack(spacing: 4) {
        Text(content.nickname)
          .b1Style()
          .foregroundColor(.odya.label.normal)
        Image("sparkle-s")
      }
      Spacer()
      if !isSearching {
        CustomIconButton("x", color: .odya.line.normal) {
          // TODO: 최근검색에서 삭제
        }
      }
    }
  }
}

// MARK: - Previews
struct FeedUserSearchView_Previews: PreviewProvider {
  static var previews: some View {
    FeedUserSearchView(isPresented: .constant(true))
  }
}

struct FeedUserSearchCell_Previews: PreviewProvider  {
  static var previews: some View {
    FeedUserSearchCell(isSearching: true, content: SearchedUserContent(userId: 1, nickname: "홍길동", profile: ProfileData(profileUrl: ""), isFollowing: false))
  }
}
