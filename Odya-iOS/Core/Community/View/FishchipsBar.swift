//
//  FishchipsBar.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FishchipsBar: View {
  // MARK: Properties
  
  @StateObject private var viewModel = TopicListViewModel()
  @Binding var selectedTopicId: Int
  
  // MARK: - Body
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        ForEach(viewModel.topicList, id: \.id) { topic in
          FishchipButton(
            isActive: selectedTopicId == topic.id ? .active : .inactive, buttonStyle: .solid, imageName: nil, labelText: topic.word,
            labelSize: .S
          ) {
            print("Fishchip Clicked")
            if selectedTopicId == topic.id {
              selectedTopicId = -1
            } else {
              selectedTopicId = topic.id
            }
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
    FishchipsBar(selectedTopicId: .constant(1))
  }
}
