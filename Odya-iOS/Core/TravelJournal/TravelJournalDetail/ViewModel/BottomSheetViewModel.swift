//
//  BottomSheetViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/08.
//

import SwiftUI

class BottomSheetViewModel: ObservableObject {

  @Published var isSheetOn: Bool = false
  @Published var sheetOffset: CGFloat = .zero
  @Published var isScrollAtTop: Bool = false
  @Published var scrollToTop: Bool = false

  let minHeight: CGFloat = UIScreen.main.bounds.height / 5 * 3
  let maxHeight: CGFloat = 60

  func isSheetOn(_ gesture: DragGesture.Value, _ geometry: GeometryProxy) -> Bool {
    return gesture.startLocation.y < geometry.frame(in: .global).midX
  }

  func setSheetHeight(_ gesture: DragGesture.Value, _ geometry: GeometryProxy) {

    func isDraggingUpwards(_ gesture: DragGesture.Value, _ geometry: GeometryProxy) -> Bool {
      if isSheetOn {
        print("\(gesture.translation.height), \(UIScreen.main.bounds.height / 2)")
        return gesture.translation.height < geometry.frame(in: .global).midX
      } else {
        return -gesture.translation.height > geometry.frame(in: .global).midX
      }
    }

    if isDraggingUpwards(gesture, geometry) {
      print("upwards")
      sheetOffset = maxHeight - minHeight
      self.isSheetOn = true
    } else {
      print("downwards")
      sheetOffset = 0
      self.isSheetOn = false
    }
  }
}
