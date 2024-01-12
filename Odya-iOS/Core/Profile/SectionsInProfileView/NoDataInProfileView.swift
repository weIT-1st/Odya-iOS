//
//  NoDataInProfileView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/08.
//

import SwiftUI

struct NoDataInProfileView: View {

  let message: String

  var body: some View {
    HStack {
      Spacer()
      Text(message)
        .b1Style()
        .foregroundColor(.odya.elevation.elev6)
        .padding(20)
      Spacer()
    }
    .frame(height: 60, alignment: .center)
    .padding(.bottom, 36)
  }
}
