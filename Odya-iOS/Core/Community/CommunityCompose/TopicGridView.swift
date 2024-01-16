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
//  let activeTextColor = Color.odya.background.normal
//  let inactiveTextColor = Color.odya.label.inactive
//  let activeBackgroundColor = Color.odya.brand.primary
//  let inactiveBackgroundColor = Color.odya.system.inactive
  
  // MARK: Body
  
  var body: some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        TopicLayout(alignment: .leading, horizontalSpacing: 10, verticalSpacng: 10) {
          ForEach(viewModel.topicList, id: \.self.id) { topic in
            FishchipButton(
              isActive: selectedTopic == topic.id ? .active : .inactive,
              buttonStyle: .solid,
              imageName: nil,
              labelText: topic.word,
              labelSize: .S
            ) {
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
//      viewModel.topicList = [Topic(id: 1, word: "바다여행"),
//                         Topic(id: 2, word: "캠핑여행"),
//                             Topic(id: 3, word: "취미여행"),
//                             Topic(id: 4, word: "식도락"),
//                             Topic(id: 5, word: "휴양지"),
//                             Topic(id: 6, word: "겨울여행"),
//                             Topic(id: 7, word: "여름여행"),
//                             Topic(id: 8, word: "꽃놀이"),
//                             Topic(id: 9, word: "가을여행"),
//                             Topic(id: 10, word: "지역축제"),
//                             Topic(id: 11, word: "가족여행"),
//                             Topic(id: 12, word: "커플여행"),
//                             Topic(id: 13, word: "나홀로여행"),
//                             Topic(id: 14, word: "촌캉스")]
    }
  }
}

// MARK: - Previews
struct TopicGridView_Previews: PreviewProvider {
  static var previews: some View {
    TopicGridView(selectedTopic: .constant(nil))
  }
}
