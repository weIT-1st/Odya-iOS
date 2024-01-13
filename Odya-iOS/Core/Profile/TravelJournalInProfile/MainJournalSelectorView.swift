//
//  MainJournalSelectorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/12.
//

import SwiftUI

struct MainJournalSelectorView: View {
  @StateObject private var view
  
  @Binding var path: NavigationPath
  @State private var selectedJournalId: Int?
  @State private var selectedJournalTitle: String?
  
  @Environment(\.dismiss) private var dismiss
  
  var isSelected: Bool {
    selectedJournalId != nil
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      LinkedTravelJournalView(path: $path, selectedJournalId: $selectedJournalId, selectedJournalTitle: $selectedJournalTitle, headerTitle: "")
      
      headerBar
    }
  }
  
  private var headerBar: some View {
    HStack {
      IconButton(isSelected ? "x" : "direction-left") {
        selectedJournalId = nil
        selectedJournalTitle = nil
        dismiss()
      }
      .frame(width: 36, height: 36)
      Spacer()
      Text("대표 여행일지")
        .h6Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      if isSelected {
        Button {
          dismiss()
        } label: {
          Text("완료")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
            .frame(width: 36, height: 36)
        }
      } else {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 36, height: 36)
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
    .background(Color.odya.background.normal)
  }
  
}
