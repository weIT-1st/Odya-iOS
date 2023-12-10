//
//  POTDFullScreen.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

struct POTDFullScreen: View {
  @Binding var images: [UserImage]

  let isMyPOTD: Bool

  @State private var isShowingMenu: Bool = false
  @State private var curImageIdx: Int
  var curImage: UserImage {
    self.images[curImageIdx]
  }

  init(_ images: Binding<[UserImage]>, selectedIdx: Int, isMyPOTD: Bool) {
    self._images = images
    self.curImageIdx = selectedIdx
    self.isMyPOTD = isMyPOTD
  }

  var body: some View {
    VStack {
      navigationBar

      TabView(selection: $curImageIdx) {
        ForEach(Array(images.enumerated()), id: \.element.id) { (idx, userImage) in
          currentImageFullView
            .tag(idx)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
  }

  private var currentImageFullView: some View {
    VStack {
      Spacer()

      AsyncImage(url: URL(string: curImage.imageUrl)!) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: UIScreen.main.bounds.height - 170)
          .clipped()
      } placeholder: {
        ProgressView()
          .frame(maxWidth: .infinity)
      }

      Spacer()
    }
  }

  private var navigationBar: some View {
    ZStack {
      CustomNavigationBar(title: "")

      if isMyPOTD {
        menuButton
      }

      Text("\(curImageIdx + 1)/\(images.count)")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }

  private var menuButton: some View {
    HStack {
      Spacer()
      IconButton("menu-meatballs-l") {
        isShowingMenu = true
      }
      .confirmationDialog("", isPresented: $isShowingMenu) {
        Button("삭제하기", role: .destructive) {
          POTDViewModel().deletePOTD(imageId: curImage.imageId) {
            let deletedImageId = curImage.imageId
            if images.count - 1 == curImageIdx {
              curImageIdx -= 1
            }
            images = images.filter { $0.imageId != deletedImageId }
          }
          isShowingMenu = false
        }
      }
    }
  }
}

//struct POTDFullScreen_Previews: PreviewProvider {
//  static var previews: some View {
//    POTDFullScreen()
//  }
//}
