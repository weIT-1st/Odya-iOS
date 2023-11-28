//
//  SplashView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import SwiftUI

struct SplashView: View {
  var body: some View {
    ZStack {
      Color.odya.background.normal
        .edgesIgnoringSafeArea(.all)
      
      Image("odya-logo-l")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 105)
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
