//
//  POTDSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import SwiftUI

extension ProfileView {
  var POTDTitle: some View {
    HStack {
      Text(isMyProfile ? "내 인생 샷" : "인생 샷")
        .h4Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      NavigationLink(destination: {
        POTDPickerView()
          .navigationBarBackButtonHidden()
      }) {
        Image("plus")
          .renderingMode(.template)
          .foregroundColor(isMyProfile ? .odya.label.normal : .clear)
          .padding(6)
      }.disabled(!isMyProfile)
    }
  }
  
  var POTDList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(profileVM.potdList, id: \.id) { image in
          POTDCardView(imageUrl: image.imageUrl, place: image.placeName)
        }
      }
    }
  }
}
