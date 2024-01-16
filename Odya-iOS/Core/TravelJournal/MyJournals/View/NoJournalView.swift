//
//  NoJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/05.
//

import SwiftUI

struct NoJournalView: View {

  @State private var isShowingComposeView: Bool = false
  
  let isFullScreen: Bool

  var body: some View {
    VStack {
      Image("noJournalImg")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.bottom, 10)

      Text("작성된 여행일지가 없어요!")
        .h6Style()
        .foregroundColor(.odya.label.normal)
        .frame(height: 13)
        .padding(.bottom, isFullScreen ? 80 : 24)
      
      CTAButton(
        isActive: .active, buttonStyle: .solid, labelText: "여행일지 작성하러가기",
        labelSize: ComponentSizeType.L,
        action: { isShowingComposeView = true }
      )
      .fullScreenCover(isPresented: $isShowingComposeView) {
        TravelJournalComposeView()
          .navigationBarHidden(true)
      }
    }
    .frame(maxWidth: .infinity)
  }

}

struct NoJournalCardView: View {
  var body: some View {
    NoJournalView(isFullScreen: false)
    .padding(.vertical, 24)
    .frame(height: 230)
    .background(Color.odya.elevation.elev3)
    .cornerRadius(Radius.large)
  }
}

struct NoJournalView_Previews: PreviewProvider {
  static var previews: some View {
    NoJournalView(isFullScreen: true)
  }
}
