//
//  AppState.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/03/03.
//

import SwiftUI

final class AppState: ObservableObject {
  @Published var activeTab: Tab = .home
  @Published var feedNavStack: [FeedStack] = []
}
