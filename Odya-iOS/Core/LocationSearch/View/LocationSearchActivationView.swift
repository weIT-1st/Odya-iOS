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
    HStack(spacing: 22) {
      Text("지금 인기있는 오댜는?")
        .detail1Style()
        .foregroundColor(.odya.label.inactive)
      Image("search")
        .renderingMode(.template)
        .foregroundColor(.odya.system.inactive)
        .frame(width: 24, height: 24)
    }
    .padding(.horizontal, 13)
    .padding(.vertical, 6)
    .background(Color.odya.elevation.elev1)
    .cornerRadius(22)
  }
}

// MARK: - Previews
struct LocationSearchActivationView_Previews: PreviewProvider {
  static var previews: some View {
    LocationSearchActivationView()
  }
}
