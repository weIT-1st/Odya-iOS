//
//  FullScreenCoverManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/11.
//

import SwiftUI

//struct FullScreen: Identifiable {
//  var id = UUID()
//  var isActive: Bool = false
//}

//extension FullScreen: Equatable {
//    static func == (lhs: FullScreen, rhs: FullScreen) -> Bool {
//      return lhs.id == rhs.id
//    }
//
//    static func != (lhs: FullScreen, rhs: FullScreen) -> Bool {
//      return lhs.id != rhs.id
//    }
//}

class FullScreenCoverManager: ObservableObject {
  @Published var activeFullScreens: [Bool] = [false]

  func newFullScreen() -> Int {
    let idx = activeFullScreens.count - 1
    activeFullScreens.append(false)
    return idx
  }
  
  func openFullScreen(idx: Int) {
    if idx > 0 {
      activeFullScreens[idx] = true
      print("open fullscreen \(idx)")
    }
  }
  
  func closeFullScreen(idx: Int) {
    if idx > 0 {
      activeFullScreens[idx] = false
      print("close fullscreen \(idx)")
    }
  }
  
  func closeAll() {
    for index in activeFullScreens.indices {
        activeFullScreens[index] = false
    }
  }
}
