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
