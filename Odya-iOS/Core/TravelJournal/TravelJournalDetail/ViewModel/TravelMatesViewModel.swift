//
//  TravelMatesViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import SwiftUI

class TravelMatesViewModel: ObservableObject {
  @Published var selectedMateId: Int = 0
  @Published var selectedMateNickname: String = ""
  @Published var selectedMateProfileUrl: String = ""
}
