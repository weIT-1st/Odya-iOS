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
}

struct POTDListView: View {
  @Binding var images: [UserImage]

  let isMyPOTD: Bool

  @State var isShowingPOTDFull: Bool = false
  @State var selectedImageIdx: Int = 0

  init(_ images: Binding<[UserImage]>, isMyPOTD: Bool) {
    self._images = images
    self.isMyPOTD = isMyPOTD
  }

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(Array(images.enumerated()), id: \.element.id) { (idx, image) in
          Button(action: {
            isShowingPOTDFull = true
            selectedImageIdx = idx
          }) {
            POTDCardView(imageUrl: image.imageUrl, place: image.placeName)
          }
        }
      }
    }
    .fullScreenCover(isPresented: $isShowingPOTDFull) {
      POTDFullScreen($images, selectedIdx: selectedImageIdx, isMyPOTD: isMyPOTD)
    }
  }
}
