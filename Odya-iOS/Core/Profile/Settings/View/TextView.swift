//
//  TextView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/21.
//

import SwiftUI

struct TextView: View {
  let title: String
  let content: String
  
  var body: some View {
    VStack {
      CustomNavigationBar(title: title)
      
      ScrollView {
        Text(content)
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .multilineTextAlignment(.leading)
      }
      .padding(.horizontal, GridLayout.side)
      .padding(.vertical, 24)
      .background(Color.odya.elevation.elev2)
    }
    .background(Color.odya.background.normal)
    .onAppear {
      print(title)
    }
    
  }
}
