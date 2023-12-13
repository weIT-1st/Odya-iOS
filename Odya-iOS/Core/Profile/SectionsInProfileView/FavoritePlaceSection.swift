//
//  FavoritePlaceSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

extension ProfileView {
  
  var favoritePlaceTitle: some View {
    getSectionTitleView(title: "관심장소")
  }
}

struct FavoritePlaceListView: View {
  // @StateObject var VM = FavoritePlaceInProfileViewModel()
  
  var body: some View {
    VStack(spacing: 0) {
      // ForEach(VM.favoritePlaces, id: \.id) { place in
      ForEach(Array(0...3), id: \.self) { idx in
        FavoritePlaceRow()
        
        if idx != 3 { // not last
          Divider().frame(height: 1).background(Color.odya.line.alternative)
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
        }
        
      }
      
      morePlacesButton
        .padding(.top, 32)
    }
      
  }
  
  var morePlacesButton: some View {
    Button(action: {
      
    }) {
      HStack(spacing: 10) {
        Text("12개의 관심장소 더보기")
          .detail1Style()
        Image("more-off")
          .renderingMode(.template)
      }
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity)
      .foregroundColor(.odya.label.assistive)
        .background(Color.odya.elevation.elev3)
        .cornerRadius(Radius.medium)
        .overlay {
          RoundedRectangle(cornerRadius: Radius.medium)
            .inset(by: 0.5)
            .stroke(Color.odya.line.alternative, lineWidth: 1)
        }
    }
  }
}

struct FavoritePlaceListView_Previews: PreviewProvider {
  static var previews: some View {
    FavoritePlaceListView()
  }
}
