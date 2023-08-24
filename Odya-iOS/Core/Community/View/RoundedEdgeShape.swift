//
//  RoundedEdgeShape.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/19.
//

import SwiftUI

enum EdgeType {
  case top
  case bottom
}

struct RoundedEdgeShape: Shape {
  // MARK: - Properties

  let edgeType: EdgeType

  // MARK: - Body

  func path(in rect: CGRect) -> Path {
    var corners = UIRectCorner()

    switch edgeType {
    case .top:
      corners = [.topLeft, .topRight]
    case .bottom:
      corners = [.bottomLeft, .bottomRight]
    }

    // create path
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: Radius.medium, height: Radius.medium))

    return Path(path.cgPath)
  }
}
