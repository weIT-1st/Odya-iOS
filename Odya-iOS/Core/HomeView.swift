//
//  HomeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/23.
//

import SwiftUI

struct HomeView: View {
  // MARK: Properties

  @State private var showLocationSearchView = false

  // MARK: Body

  var body: some View {
    ZStack(alignment: .top) {
      MapView()
        .edgesIgnoringSafeArea(.top)

      if showLocationSearchView {
        Color.odya.blackopacity.baseBlackAlpha50
        LocationSearchView(showLocationSearchView: $showLocationSearchView)
      } else {
        HStack {
          LocationSearchActivationView()
            .onTapGesture {
              showLocationSearchView = true
            }
          Spacer()
          // TODO: 내 오댜 / 친구 오댜만 보기 버튼
        }
        .padding(.leading, 23)
      }
    }
  }
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
