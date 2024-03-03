//
//  NavStacks.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/03/03.
//

import Foundation

enum FeedStack: Hashable {
  case detail(Int)
  case createFeed
  case createJournal
  case activity
  case notification
  case journalDetail(Int)
}
