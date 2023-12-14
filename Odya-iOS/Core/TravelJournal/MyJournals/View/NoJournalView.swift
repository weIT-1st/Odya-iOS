//
//  NoJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/05.
//

import SwiftUI

struct NoJournalView: View {

  @State private var isShowingComposeView: Bool = false
  
  var body: some View {
    VStack {
      Spacer()
      Image("noJournalImg")
        .resizable()
        .scaledToFit()
      Text("작성된 여행일지가 없어요!")
        .h6Style()
        .foregroundColor(.odya.label.normal)
        .padding(.bottom, 80)
      ZStack {
        CTAButton(
          isActive: .active, buttonStyle: .solid, labelText: "여행일지 작성하러가기",
          labelSize: ComponentSizeType.L,
          action: {})
        
        Button(action: {isShowingComposeView = true}) {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: ComponentSizeType.L.CTAButtonWidth, height: 48)
        }
        .fullScreenCover(isPresented: $isShowingComposeView) {
          TravelJournalComposeView()
            .navigationBarHidden(true)
        } 
      }

      Spacer()
    }.background(Color.odya.background.normal)

  }

}
