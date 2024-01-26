//
//  TopicsView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/27.
//

import SwiftUI

/// 사용자 관심 토픽 선택 뷰
struct RegisterTopicsView: View {
  // MARK: Properties
  
  /// 토픽 api
  @StateObject var topicListVM = TopicListViewModel()
  
  /// 회원가입 단계
  @Binding var signUpStep: Int
  
  /// 사용자 닉네임
  let nickname: String
  
  /// 화면에 표시되는 토픽 리스트
  /// word: 토픽 내용, isPicked: 선택 여부
  @State private var displayedTopics : [Int: (word: String, isPicked: Bool)] = [:]
  
  /// 토픽리스트를 화면에 표시할 준비가 되었는지 여부
  /// 서버로부터 토픽 리스트와 관심 토픽 리스트를 모두 받아왔을 때 ready
  @State private var isReady: Bool = false
  
  /// 다음 단계로 넘어갈 수 있는지 여부
  /// 최소 3개의 토픽이 선택되어야 함
  private var isNextButtonActive: ButtonActiveSate {
    return displayedTopics.filter{ $0.value.isPicked }.count >= 3 ? .active : .inactive
  }
  
  // MARK: Init
  
  init(_ step: Binding<Int>, nickname: String) {
    self._signUpStep = step
    self.nickname = nickname
  }
  
  // MARK: Body
  
  var body: some View {
    VStack {
      
      Spacer()
      
      VStack(alignment: .leading, spacing: 0) {
        // title
        titleText
          .frame(height: 160) // 뒷페이지와 title height 맞추기용
        
        // topic list
        if !isReady {
          ProgressView()
            .frame(maxWidth: .infinity)
        } else {
          topicsGridView()
        }
      }
      .frame(minHeight: 300, maxHeight: 380)
      .padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      // next button
      CTAButton( isActive: isNextButtonActive, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        self.updateMyTopics()
        signUpStep += 1
      }
      .padding(.bottom, 45)
    }
    // 토픽 버튼 초기화, 관심 토픽인 경우 isPicked = true
    .onChange(of: topicListVM.topicList) { topicList in
      topicList.forEach { topic in
        displayedTopics[topic.id] = (word: topic.word, isPicked: false)
      }
      topicListVM.fetchMyTopicList() { _ in
        topicListVM.myTopicList.forEach { topic in
          displayedTopics[topic.topicId] = (word: topic.topicWord, isPicked: true)
        }
        self.isReady = true
      }
    }
    /*/ for test
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
    } */
  }
  
  // MARK: Title
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          Text(nickname)
            .foregroundColor(.odya.brand.primary)
          Text("님은")
            .foregroundColor(.odya.label.normal)
        }
        Text("어떤 여행을 좋아하시나요?")
          .foregroundColor(.odya.label.normal)
      }
      .h3Style()
      .frame(height: 49)
      
      Text("취향을 선택하고 나에게 맞는 홈을 받아보세요")
        .b2Style()
        .foregroundColor(.odya.label.normal)
        .frame(height: 12)
      
      Text("최소 3개 이상")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
        .frame(height: 12)
      
      Spacer()
    }
  }
}

// MARK: Topics Grid View
extension RegisterTopicsView {
  /// 토픽 리스트가 그리드 형태로 나열됨
  /// 화면의 가로 길이에 맞춰 최대한 많은 토픽이 나열되면 하나의 row에 있는 토픽들은 가운데 정렬
  private func topicsGridView() -> some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        TopicLayout(alignment: .center, horizontalSpacing: 5, verticalSpacng: 10) {
          ForEach(displayedTopics.keys.sorted(), id: \.self) { id in
            buttonItem(for: id)
          }
        }
      }
    }
  }

  /// 토픽 버튼, 클릭 시 선택/선택 해제 됨
  private func buttonItem(for id: Int) -> some View {
    let topic = displayedTopics[id]!
    return FishchipButton(
        isActive: topic.isPicked ? .active : .inactive,
        buttonStyle: .solid,
        inactiveButtonStyle: .solid,
        imageName: nil,
        labelText: topic.word,
        labelSize: .M
    ) {
      displayedTopics[id] = (word: topic.word, isPicked: !topic.isPicked)
        displayedTopics[id] = (word: topic.word, isPicked: !topic.isPicked)
    }.animation(.easeInOut, value: displayedTopics[id]!.isPicked)
      
  }
}

// MARK: Update My Topics Function
extension RegisterTopicsView {
  private func updateMyTopics() {
    let deleteList : [Int] = displayedTopics.filter{ topic in
      topic.value.isPicked == false
      && topicListVM.myTopicList.contains(where : {$0.topicId == topic.key})
    }.map{ $0.key }
    deleteList.forEach { id in
      topicListVM.deleteMyTopic(id: id)
    }
    
    let addList : [Int] = displayedTopics.filter{ topic in
      topic.value.isPicked == true
      && !topicListVM.myTopicList.contains(where : {$0.topicId == topic.key})
    }.map{ $0.key }
    if !addList.isEmpty {
      topicListVM.addMyTopics(idList: addList)
    }
  }
}

struct RegisterTopicsView_Previews: PreviewProvider {
  static var previews: some View {
    RegisterTopicsView(.constant(3), nickname: "길동아밥먹자")
  }
}
