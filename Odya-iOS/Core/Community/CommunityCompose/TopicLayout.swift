//
//  TopicLayout.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/24.
//

import SwiftUI

/// 토픽 그리드 뷰의 레이아웃
struct TopicLayout: Layout {
  // MARK: Properties

  var alignment: Alignment = .leading
  /// 가로, 세로 여백
  var spacing: CGFloat = 10

  // MARK: Layout

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let maxWidth = proposal.width ?? 0
    var height: CGFloat = 0
    let rows = generateRows(maxWidth, proposal, subviews)

    for (index, row) in rows.enumerated() {
      // Finding max Height in each row and adding it to the View's Total Height
      if index == (rows.count - 1) {
        height += row.maxHeight(proposal)
      } else {
        height += row.maxHeight(proposal) + spacing
      }
    }

    return .init(width: maxWidth, height: height)
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    var origin = bounds.origin
    let maxWidth = bounds.width
    let rows = generateRows(maxWidth, proposal, subviews)

    for row in rows {
      origin.x = 0

      for view in row {
        let viewSize = view.sizeThatFits(proposal)
        view.place(at: origin, proposal: proposal)
        origin.x += (viewSize.width + spacing)
      }

      origin.y += row.maxHeight(proposal) + spacing
    }
  }

  // MARK: Helper functions

  /// 사이즈에 맞춰 rows 생성
  func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews)
    -> [[LayoutSubviews.Element]]
  {
    var row: [LayoutSubviews.Element] = []
    var rows: [[LayoutSubviews.Element]] = []

    /// Origin
    var origin = CGRect.zero.origin

    for view in subviews {
      let viewSize = view.sizeThatFits(proposal)

      // 새로운 행으로
      if (origin.x + viewSize.width + spacing) > maxWidth {
        rows.append(row)
        row.removeAll()

        origin.x = 0
        row.append(view)
        origin.x += (viewSize.width + spacing)
      } else {
        // 같은 행에 아이템 추가
        row.append(view)
        origin.x += (viewSize.width + spacing)
      }
    }

    /// Checking for any exhaust row
    if !row.isEmpty {
      rows.append(row)
      row.removeAll()
    }

    return rows
  }
}

extension [LayoutSubviews.Element] {
  func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
    return self.compactMap { view in
      return view.sizeThatFits(proposal).height
    }.max() ?? 0
  }
}
