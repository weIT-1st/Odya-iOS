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

/// 피드 디테일 조회시 가져오는 토픽 데이터 모델
struct FeedDetailTopic: Codable {
    let id: Int
    let topic: String
}
