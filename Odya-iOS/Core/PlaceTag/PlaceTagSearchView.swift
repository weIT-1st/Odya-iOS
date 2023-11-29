//
//  PlaceTagSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI

/// 검색창 + 검색결과 뷰
struct PlaceTagSearchView: View {
  @StateObject private var viewModel = PlaceTagSearchViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      // search bar
      HStack {
        TextField("장소를 찾아보세요!", text: $viewModel.queryFragment)
          .b1Style()
          .foregroundColor(Color.odya.label.inactive)
          .padding(.leading, 20)
        Spacer()
        Button {
          // action: 검색
          viewModel.searchPlace()
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
      
      ScrollView {
        VStack(spacing: 8) {
          ForEach(viewModel.searchResults, id: \.self) { result in
            PlaceTagSearchResultCell(title: result.attributedPrimaryText.string, address: result.attributedSecondaryText?.string ?? "")
            Divider()
          }
        }
      }
    }
    .toolbar(.hidden)
  }
}

/// 검색 결과인 장소이름, 주소를 표시하는 셀
struct PlaceTagSearchResultCell: View {
  // MARK: Properties
  let title: String
  let address: String
  
  // MARK: Init
  init(title: String, address: String) {
    self.title = title
    self.address = address
  }
  
  // MARK: Body
  var body: some View {
    HStack {
      VStack(spacing: 8) {
        HStack {
          Text(title)
            .b1Style()
            .foregroundColor(Color.odya.label.normal)
          Spacer()
        }
        HStack {
          Text(address)
            .detail2Style()
            .foregroundColor(Color.odya.label.alternative)
          Spacer()
        }
      }
      
      Spacer()
      
      Button {
        // action: 장소 선택
      } label: {
        Image("system-check-circle")
          .renderingMode(.template)
          .foregroundColor(Color.odya.system.inactive)
          .padding(10)
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 8)
  }
}

// MARK: - Previews
struct PlaceTagSearchView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceTagSearchView()
  }
}

