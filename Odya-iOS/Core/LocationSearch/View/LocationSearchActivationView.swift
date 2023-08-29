//
//  LocationSearchActivationView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

struct LocationSearchActivationView: View {
  // MARK: - Body
  var body: some View {
    VStack {
      HStack {
        Text("어디로 가시나요?")
          .foregroundColor(Color(.darkGray))
          .padding(.horizontal)
        Spacer()
        Image(systemName: "magnifyingglass")
          .padding(.horizontal)
      }
      .padding(.horizontal, 16)
      .frame(height: 46)
      .border(.white)
      .background(Color.odya.background.normal)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(.clear)
  }
}

// MARK: - Previews
struct LocationSearchActivationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchActivationView()
  }
}
