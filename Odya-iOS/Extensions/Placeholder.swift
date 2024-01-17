//
//  Placeholder.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/02.
//

import SwiftUI

/// 플레이스 홀더 커스텀
/// ex) TextField의 폰트와 플레이스홀더 폰트를 다르게 지정해야 하는 경우
extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}
