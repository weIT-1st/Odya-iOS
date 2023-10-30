//
//  TopicGridView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/21.
//

import SwiftUI

struct TopicGridView: View {
  // MARK: Properties

  /// 선택된 토픽
  @State private var selectedTopic: String = ""

  /// color
  let activeTextColor = Color.odya.background.normal
  let inactiveTextColor = Color.odya.label.inactive
  let activeBackgroundColor = Color.odya.brand.primary
  let inactiveBackgroundColor = Color.odya.system.inactive

  /// 테스트 토픽 리스트
  let testTopicList = [
    "바다여행", "캠핑여행", "식도락", "취미여행", "휴양지", "여름여행", "가을여행", "겨울여행", "지역축제", "가족여행", "커플여행",
  ]

  // MARK: Body

  var body: some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        TopicLayout {
          ForEach(testTopicList, id: \.self) { topic in
            Text(topic)
              .detail1Style()
              .foregroundColor(topic == selectedTopic ? activeTextColor : inactiveTextColor)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(topic == selectedTopic ? activeBackgroundColor : inactiveBackgroundColor)
              .cornerRadius(100)
              .onTapGesture {
                selectedTopic = topic
              }
          }
        }
      }
    }
    .padding(12)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.medium)
  }
}

// MARK: - Previews
struct TopicGridView_Previews: PreviewProvider {
  static var previews: some View {
    TopicGridView()
  }
}
