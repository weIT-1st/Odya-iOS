//
//  FeedToolBar.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FeedToolBar: View {
  // MARK: Properties
  
  @State private var showSearchView = false
  
  // MARK: - Body

  var body: some View {
    ZStack {
      HStack(alignment: .center) {
        // symbol mark
        Image("odya-logo-s")
          .frame(width: 48, height: 48, alignment: .center)

        Spacer()

        // search icon
        Button {
          showSearchView.toggle()
        } label: {
          Image("search")
            .padding(10)
            .frame(width: 48, height: 48, alignment: .center)
        }

        // alarm on/off
        Button {
          // action: show alarm
        } label: {
          Image("alarm-on")
            .padding(10)
            .frame(width: 48, height: 48, alignment: .center)
        }
      }  // HStack
      .frame(height: 56)
      
      if showSearchView {
        FeedUserSearchView(isPresented: $showSearchView)
      }
    }
  }
}

// MARK: - Preview

struct FeedToolBar_Previews: PreviewProvider {
  static var previews: some View {
    FeedToolBar()
  }
}
