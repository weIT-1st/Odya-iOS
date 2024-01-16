//
//  POTDFullScreen.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

/// 인생샷 확대보기 뷰
/// 내 인생샷인 경우 우측상단에 메뉴 버튼 포함
/// 메뉴 버튼에 있는 삭제로 인생샷 제거 가능
struct POTDFullScreen: View {
  /// 인생샷 리스트
  @Binding var images: [UserImage]
  /// 내 인생샷인지 여부
  let isMyPOTD: Bool
  /// 메뉴 버튼 클릭시 활성화
  @State private var isShowingMenu: Bool = false
  /// 현재 화면에 표시된 인생샷 인덱스
  @State private var curImageIdx: Int
  /// 현재 화면에 표시된 인생샷
  var curImage: UserImage {
    self.images[curImageIdx]
  }

  init(_ images: Binding<[UserImage]>, selectedIdx: Int, isMyPOTD: Bool) {
    self._images = images
    self.curImageIdx = selectedIdx
    self.isMyPOTD = isMyPOTD
  }

  // MARK: Body
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

  /// 화면에 꽉 차게 인생샷 확대한 뷰
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

  /// 네비게이션 바
  /// 현재 화면에 표시된 인생샷이 몇 번째 인생샷인지 인디케이터 포함
  /// 내 인생샷인 경우 삭제를 위한 메뉴 버튼 포함
  private var navigationBar: some View {
    ZStack {
      CustomNavigationBar(title: "")

      // 인디케이터
      Text("\(curImageIdx + 1)/\(images.count)")
        .b2Style()
        .foregroundColor(.odya.label.assistive)

      // 메뉴버튼
      if isMyPOTD {
        menuButton
      }
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
            // 삭제한 사진이 마지막 사진인 경우, 인덱스 오류 방지
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
