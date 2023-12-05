//
//  Topic.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/31.
//

import Foundation

struct Topic: Codable {
  let id: Int
  let word: String
}

typealias TopicList = [Topic]

extension Topic: Equatable {
  static func == (lhs: Topic, rhs: Topic) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func !=(lhs: Topic, rhs: Topic) -> Bool {
    return lhs.id != rhs.id
  }
}

/// 내 관심 토픽
struct MyTopic: Codable {
  let id: Int
  let userId: Int
  let topicId: Int
  let topicWord: String
}

extension MyTopic: Equatable {
  static func == (lhs: MyTopic, rhs: MyTopic) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func !=(lhs: MyTopic, rhs: MyTopic) -> Bool {
    return lhs.id != rhs.id
  }
}

/// 피드 디테일 조회시 가져오는 토픽 데이터 모델
struct FeedDetailTopic: Codable {
    let id: Int
    let topic: String
}
