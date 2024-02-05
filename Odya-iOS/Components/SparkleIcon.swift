//
//  SparkleIcon.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/11.
//

import SwiftUI

struct SparkleIcon: View {
  var body: some View {
    Image("sparkle-filled-l")
      .shadow(color: .odya.brand.primary.opacity(0.8), radius: 9, x: 0, y: 0)
  }
}
