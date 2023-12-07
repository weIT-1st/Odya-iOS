//
//  POTDFullScreen.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

struct POTDFullScreen: View {
  @State private var isShowingMenu: Bool = false
  
  var body: some View {
    VStack {
      navigationBar
      
      Spacer()
      
      Image("photo_example")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: UIScreen.main.bounds.height - 170)
        .clipped()
      
      Spacer()
    }
  }
  
  private var navigationBar: some View {
    ZStack {
      CustomNavigationBar(title: "")
      
      HStack {
        Spacer()
        IconButton("menu-meatballs-l") {
          isShowingMenu = true
        }
        .confirmationDialog("", isPresented: $isShowingMenu) {
          Button("삭제하기", role: .destructive) {
            print("인생샷 삭제")
            isShowingMenu = false
          }
        }
      }
      
      Text("1/10")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }
}


struct POTDFullScreen_Previews: PreviewProvider {
  static var previews: some View {
    POTDFullScreen()
  }
}
