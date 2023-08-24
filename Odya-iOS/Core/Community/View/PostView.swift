//
//  PostView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct PostView: View {
  // MARK: - Body

  var body: some View {
    VStack {
      PostImageView()

      PostContentView()
    }
  }
}

// MARK: - Preview
struct PostView_Previews: PreviewProvider {
  static var previews: some View {
    PostView()
  }
}
