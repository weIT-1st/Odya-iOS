//
//  TopicGridView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/21.
//

import SwiftUI

struct TopicGridView: View {
  // MARK: Properties

  @StateObject private var viewModel = TopicListViewModel()
  /// 선택된 토픽
  @Binding var selectedTopic: Int?

  /// color
  let activeTextColor = Color.odya.background.normal
  let inactiveTextColor = Color.odya.label.inactive
  let activeBackgroundColor = Color.odya.brand.primary
  let inactiveBackgroundColor = Color.odya.system.inactive

  // MARK: Body

  var body: some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        TopicLayout {
          ForEach(viewModel.topicList, id: \.self.id) { topic in
            Text(topic.word)
              .detail1Style()
              .foregroundColor(topic.id == selectedTopic ? activeTextColor : inactiveTextColor)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(topic.id == selectedTopic ? activeBackgroundColor : inactiveBackgroundColor)
              .cornerRadius(100)
              .onTapGesture {
                  if selectedTopic == topic.id {
                      selectedTopic = nil
                  } else {
                      selectedTopic = topic.id
                  }
              }
          }
        }
      }
    }
    .padding(12)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.medium)
    .onAppear {
        viewModel.fetchTopicList()
    }
  }
}

// MARK: - Previews
struct TopicGridView_Previews: PreviewProvider {
  static var previews: some View {
      TopicGridView(selectedTopic: .constant(nil))
  }
}
