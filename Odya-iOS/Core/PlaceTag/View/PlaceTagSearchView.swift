//
//  PlaceTagSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI

/// 검색창 + 검색결과 뷰
struct PlaceTagSearchView: View {
  // MARK: - Properties
  @Binding var placeId: String
  @State private var searchText: String = ""
  @EnvironmentObject var viewModel: PlaceTagSearchViewModel
  
  // MARK: - Body
  var body: some View {
    VStack(spacing: 0) {
      searchBar
      
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(spacing: 8) {
          ForEach(viewModel.searchResults, id: \.self) { result in
            PlaceTagSearchResultCell(title: result.attributedPrimaryText.string, address: result.attributedSecondaryText?.string ?? "")
              .onTapGesture {
                viewModel.selectPlace(placeId: result.placeID)
              }
            Divider()
          }
        }
      }
    }
    .frame(alignment: .top)
  }
  
  private var searchBar: some View {
    HStack {
      TextField("장소를 찾아보세요!", text: $searchText)
        .b1Style()
        .foregroundColor(Color.odya.label.normal)
        .padding(.leading, 20)
      Spacer()
      Button {
        // action: 검색
        viewModel.searchPlace(query: searchText)
      } label: {
        Image("search")
          .resizable()
          .colorMultiply(Color.odya.label.inactive)
          .frame(width: 24, height: 24, alignment: .center)
      }
      .frame(width: 48, height: 48)
    }
    .background(Color.odya.elevation.elev5)
    .cornerRadius(Radius.medium)
    .padding(.vertical, 12)
  }
}

// MARK: - Previews
struct PlaceTagSearchView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceTagSearchView(placeId: .constant(""))
  }
}

