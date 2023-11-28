//
//  TopicsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/27.
//

import SwiftUI

// 배열을 원하는 크기로 나누는 extension
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

struct RegisterTopicsView: View {
//  @EnvironmentObject var signUpVM: SignUpViewModel
  
//  var nickname: String { signUpVM.nickname }
  let nickname: String = "길동아밥먹자"
  @State private var displayedTopics : [Int: (word: String, isPicked: Bool)] = [:]
  
  private var isNextButtonActive: ButtonActiveSate {
    return displayedTopics.filter{ $0.value.isPicked }.count >= 3 ? .active : .inactive
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(alignment: .leading) {
        titleText
          .padding(.bottom, 70)
        
        GeometryReader { geometry in
            self.generateTopicButtons(in: geometry)
        }
        
//        VStack(alignment: .center) {
//          LazyVGrid(columns: [GridItem(.adaptive(minimum: 70, maximum: 100))], alignment: .center, spacing: 10) {
//            ForEach(displayedTopics.keys.sorted(), id: \.self) { id in
//              if let topic = displayedTopics[id] {
//                FishchipButton(
//                  isActive: topic.isPicked ? .active : .inactive,
//                  buttonStyle: .solid,
//                  imageName: nil,
//                  labelText: topic.word,
//                  labelSize: .M
//                ) {
//
//                }
//              }
//            }
//          }
//        }
        
      }.padding(.horizontal, GridLayout.side)
      
      
      Spacer()
      
      // next button
      CTAButton( isActive: isNextButtonActive, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        
      }
      .padding(.bottom, 45)
    }
    .onAppear {
      displayedTopics = [1: (word: "바다여행", isPicked: false),
                         2: (word: "캠핑여행", isPicked: false),
                         3: (word: "취미여행", isPicked: false),
                         4: (word: "식도락", isPicked: false),
                         5: (word: "휴양지", isPicked: false),
                         6: (word: "겨울여행", isPicked: false),
                         7: (word: "여름여행", isPicked: false),
                         8: (word: "꽃놀이", isPicked: false),
                         9: (word: "가을여행", isPicked: false),
                         10: (word: "지역축제", isPicked: false),
                         11: (word: "가족여행", isPicked: false),
                         12: (word: "커플여행", isPicked: false),
                         13: (word: "나홀로여행", isPicked: false),
                         14: (word: "촌캉스", isPicked: false)]
//      displayedTopics = [:]
//      signUpVM.topicListVM.topicList.forEach { topic in
//        displayedTopics[topic.id] = (word: topic.word, isPicked: false)
//      }
//      signUpVM.favoriteTopics.forEach { topic in
//        displayedTopics[topic.id] =  (word: topic.word, isPicked: true)
//      }
    }
  }
  
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 10) {
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          Text(nickname)
            .foregroundColor(.odya.brand.primary)
          Text("님의")
            .foregroundColor(.odya.label.normal)
        }
        Text("관심 키워드를 알려주세요!")
          .foregroundColor(.odya.label.normal)
      }.h3Style()
      
      Text("최소 3개 이상")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }
}

extension RegisterTopicsView {
  private func generateTopicButtons(in g: GeometryProxy) -> some View {
    var width: CGFloat = .zero
    var height: CGFloat = .zero
    
    return ZStack(alignment: .topLeading) {
      ForEach(displayedTopics.keys.sorted(), id: \.self) { id in
        buttonItem(for: id)
          .padding(.horizontal, 5)
          .padding(.vertical, 10)
          .alignmentGuide(.leading, computeValue: { d in
            if (abs(width - d.width) > g.size.width) {
              width = 0
              height -= d.height
            }
            let result = width
            if id == displayedTopics.keys.sorted().last! {
              width = 0 //last item
            } else {
              width -= d.width
            }
            return result
          })
          .alignmentGuide(.top, computeValue: {d in
            let result = height
            if id == displayedTopics.keys.sorted().last! {
              height = 0 // last item
            }
            return result
          })
      }
    }
  }

  func buttonItem(for id: Int) -> some View {
    let topic = displayedTopics[id]!
    return FishchipButton(
        isActive: topic.isPicked ? .active : .inactive,
        buttonStyle: .solid,
        imageName: nil,
        labelText: topic.word,
        labelSize: .M
      ) {
        
      }
      .onTapGesture {
        displayedTopics[id] = (word: topic.word, isPicked: !topic.isPicked)
      }
  }
}

struct RegisterTopicsView_Previews: PreviewProvider {
  static var previews: some View {
    RegisterTopicsView()
  }
}
