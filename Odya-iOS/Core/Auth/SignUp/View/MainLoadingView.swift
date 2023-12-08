//
//  MainLoadingView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/28.
//

import SwiftUI

struct MainLoadingView: View {
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Image("main-loading-bg")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: screenWidth, height: screenHeight)
        .clipped()
        .ignoresSafeArea()

      Text("메인페이지를 \n생성중이에요")
        .h2Style()
        .foregroundColor(.odya.label.normal)
        .offset(x: 50, y: screenHeight / 7)

      let talkImgWidth = screenWidth / 1.5
      Image("main-loading-talk")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: talkImgWidth)
        .rotationEffect(Angle(degrees: 24.8))
        .offset(x: -(talkImgWidth / 3.5), y: screenHeight / 3.5)
      
      let searchImgWidth = screenWidth / 1.5
      Image("main-loading-search")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: searchImgWidth)
        .rotationEffect(Angle(degrees: 12.45))
        .offset(x: screenWidth - (searchImgWidth / 1.5), y: screenHeight / 6)
      
      let placeImgWidth = screenWidth / 1.1
      Image("main-loading-place")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: placeImgWidth)
        .offset(x: screenWidth - (placeImgWidth / 1.4), y: screenHeight - (placeImgWidth * 1.1))
    }
    
  }
}

struct MainLoadingView_Priviews: PreviewProvider {
  static var previews: some View {
    MainLoadingView()
  }
}
