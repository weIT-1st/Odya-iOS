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
  @Binding var rootTabViewIdx: Int
  @EnvironmentObject var VM: FavoritePlaceInProfileViewModel
  
  var body: some View {
    VStack(spacing: 32) {
      if VM.isFavoritePlacesLoading {
        ProgressView()
          .frame(height: 200)
          .frame(maxWidth: .infinity)
      }
      
      else if VM.favoritePlaces.isEmpty {
        NoDataInProfileView(message: "관심장소가 없어요.")
      }
      
      else {
        ForEach(VM.favoritePlaces, id: \.id) { place in
          VStack(spacing: 0) {
            FavoritePlaceRow(favoritePlace: place)
            
            if let last = VM.favoritePlaces.last,
               place.id != last.id { // not last
              Divider().frame(height: 1).background(Color.odya.line.alternative)
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
          }
        }
        
        morePlacesButton
      }
    }
    .task {
      await VM.fetchDataAsync()
    }
    .onDisappear {
      VM.initData()
    }

  }
  
  var morePlacesButton: some View {
    Button(action: {
      rootTabViewIdx = 0
    }) {
      HStack(spacing: 10) {
        Text("\(VM.placesCount)개의 관심장소 더보기")
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

//struct FavoritePlaceListView_Previews: PreviewProvider {
//  static var previews: some View {
//    FavoritePlaceListView(rootTabViewIdx: .constant(3))
//  }
//}
