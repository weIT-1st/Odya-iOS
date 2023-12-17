//
//  OffsettableScrollView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/02.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct OffsettableScrollView<T: View>: View {
  let axes: Axis.Set
  let showsIndicator: Bool
  let onOffsetChanged: (CGPoint) -> Void
  let content: T
  @Binding var shouldScrollToTop: Bool

  init(
    axes: Axis.Set = .vertical,
    showsIndicator: Bool = true,
    shouldScrollToTop: Binding<Bool>,
    onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: () -> T
  ) {
    self.axes = axes
    self.showsIndicator = showsIndicator
    self.onOffsetChanged = onOffsetChanged
    self.content = content()
    self._shouldScrollToTop = shouldScrollToTop
  }

  var body: some View {
    ScrollViewReader { scrollProxy in
      ScrollView(axes, showsIndicators: showsIndicator) {
        GeometryReader { proxy in
          Color.clear.preference(
            key: OffsetPreferenceKey.self,
            value: proxy.frame(
              in: .named("ScrollViewOrigin")
            ).origin
          )
        }
        .frame(width: 0, height: 0)
        content
          .id("ScrollToTop")
      }
      .coordinateSpace(name: "ScrollViewOrigin")
      .onPreferenceChange(
        OffsetPreferenceKey.self,
        perform: onOffsetChanged)
      .onChange(of: shouldScrollToTop) { shouldScrollToTop in
        if shouldScrollToTop {
          withAnimation(.default) {
            scrollProxy.scrollTo("ScrollToTop", anchor: .top)
          }
          self.shouldScrollToTop = false
        }
      }
    }
  }
}
