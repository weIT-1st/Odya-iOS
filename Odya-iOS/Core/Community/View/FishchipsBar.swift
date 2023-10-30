//
//  FishchipsBar.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FishchipsBar: View {
    // MARK: Properties
    
    @StateObject private var viewModel = FishchipsViewModel()
    
  // MARK: - Body

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
          ForEach(viewModel.topicList, id: \.id) { topic in
              FishchipButton(
                isActive: .inactive, buttonStyle: .solid, imageName: nil, labelText: topic.word,
                  labelSize: .S
              ) {
                // action
              }
          }
      }  // HStack
      .padding(.leading, 20)
      .frame(height: 48, alignment: .leading)
      .onAppear {
          viewModel.fetchTopicList()
      }
    }  // ScrollView
  }
}

// MARK: - Preview

struct FishchipsBar_Previews: PreviewProvider {
  static var previews: some View {
    FishchipsBar()
  }
}
