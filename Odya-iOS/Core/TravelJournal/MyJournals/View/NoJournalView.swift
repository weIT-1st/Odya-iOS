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
        .aspectRatio(contentMode: .fit)
      
      Text("작성된 여행일지가 없어요!")
        .h6Style()
        .foregroundColor(.odya.label.normal)
        .padding(.bottom, 80)
      
      CTAButton(
        isActive: .active, buttonStyle: .solid, labelText: "여행일지 작성하러가기",
        labelSize: ComponentSizeType.L,
        action: { isShowingComposeView = true })
      .fullScreenCover(isPresented: $isShowingComposeView) {
        TravelJournalComposeView()
          .navigationBarHidden(true)
      }
      
      Spacer()
      
    }
    .padding(.bottom, 80)
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    .background(Color.odya.background.normal)
    .ignoresSafeArea()

  }

}

struct NoJournalView_Previews: PreviewProvider {
  static var previews: some View {
    NoJournalView()
  }
}
