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
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                Button {
                    showLocationSearchView = false
                    viewModel.queryFragment = ""
                } label: {
                    Image(systemName: "lessthan")
                        .padding(.horizontal, 8)
                        .tint(.black)
                }
                
                TextField("장소, 지역 검색", text: $viewModel.queryFragment)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.appendRecentSearch()
                    }
                
                Button {
                    viewModel.queryFragment = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                }
                .padding(.horizontal)
                
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 46)
            .border(.black)
            .padding(.bottom)
            
            // Show recent searches if search query is empty
            if viewModel.queryFragment.isEmpty {
                HStack(alignment: .center) {
                    Text("최근검색어")
                        .font(.system(size: 15))
                        .bold()
                    // 검색어 리스트 출력
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(viewModel.recentSearchTexts.reversed(), id: \.self) { text in
                                RecentSearchCell(searchText: text)
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
            }
            
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
            }
        }
        .background(.white)
    }
}

// MARK: - Previews
struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocationSearchView: .constant(true))
    }
}
