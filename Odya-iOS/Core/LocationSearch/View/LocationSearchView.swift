//
//  LocationSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

struct LocationSearchView: View {
  // MARK: - Properties
  @StateObject var viewModel = LocationSearchViewModel()
  @Binding var showLocationSearchView: Bool
  
  let rankColumns = Array(repeating: GridItem(spacing: 0), count: 5)
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 0) {
      searchBar
        .padding(.horizontal, GridLayout.side)
        .padding(.bottom, 26)
      
      // Show recent searches if search query is empty
      if viewModel.queryFragment.isEmpty {
        VStack(spacing: 0) {
          HStack(alignment: .center) {
            Text("최근검색")
              .b1Style()
              .foregroundColor(.odya.label.normal)
            Spacer()
            Button {
              // action: 검색어 모두 삭제
              viewModel.removeAllRecentSearch()
            } label: {
              Text("모두삭제")
                .detail2Style()
                .foregroundColor(.odya.label.assistive)
            }
          }
          .padding(.horizontal, 8)
          
          // 검색어 리스트 출력
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
              ForEach(viewModel.recentSearchTexts.reversed(), id: \.self) { text in
                RecentSearchCell(searchText: text)
                  .environmentObject(viewModel)
              }
            }
            .padding(.vertical, 12)
          }
        }
        .padding(.horizontal, GridLayout.side)

        Rectangle()
          .foregroundColor(.odya.background.dimmed_dark)
          .frame(height: 8)
          .frame(maxWidth: .infinity)
        
        // 랭킹
        HStack(alignment: .center) {
          Text("🔥 오댜 핫플")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Spacer()
          // TODO: 랭킹 기준시간
          Text("09.09 10:00 기준")
            .detail2Style()
            .foregroundColor(.odya.label.assistive)
        }
        .padding(.leading, 25)
        .padding(.trailing, 21)
        .padding(.top, 24)
        .padding(.bottom, 16)
        
        LazyHGrid(rows: rankColumns, spacing: 12) {
          ForEach(0..<10) { num in
            Text("\(num)")
          }
        }
        .padding(.horizontal, GridLayout.side)
        
      } else {
        // 검색 자동완성 결과 출력
        ScrollView {
          VStack(alignment: .leading) {
            ForEach(viewModel.searchResults, id: \.self) { result in
              let title = result.attributedPrimaryText.string
              let subtitle = result.attributedSecondaryText?.string ?? ""
              
              LocationSearchResultCell(title: title, subtitle: subtitle)
              
              // Select cell -> Show detail place info
            }
          }
        } // ScrollView
      } // if-else
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 24)
    .background(Color.odya.elevation.elev3)
  }
  
  private var searchBar: some View {
    HStack(spacing: 13) {
      HStack {
        TextField("", text: $viewModel.queryFragment)
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .placeholder(when: viewModel.queryFragment.isEmpty) {
            Text("⚡️ 어디에 가고싶으신가요?")
              .b2Style()
              .foregroundColor(.odya.label.assistive)
          }
          .submitLabel(.search)
          .onSubmit {
            viewModel.appendRecentSearch()
          }
        
        Spacer()
        
        if viewModel.queryFragment.isEmpty {
          Image("search")
            .renderingMode(.template)
            .foregroundColor(.odya.label.assistive)
            .frame(width: 36, height: 36)
        } else {
          Button {
            viewModel.queryFragment = ""
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
        showLocationSearchView = false
        viewModel.queryFragment = ""
      } label: {
        Text("취소")
          .b2Style()
          .foregroundColor(.odya.label.normal)
          .padding(10)
      }
    }
  }
}

// MARK: - Previews
struct LocationSearchView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchView(showLocationSearchView: .constant(true))
  }
}
