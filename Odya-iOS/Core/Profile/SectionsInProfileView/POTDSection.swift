//
//  POTDSection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import SwiftUI

extension ProfileView {
  
  /// 인생샷 부분 타이틀
  /// 내 프로필뷰인 경우, 인생샷 추가 버튼 포함
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

/// 인생샷 가로 스크롤뷰
/// 클릭 시 확대보기 가능
struct POTDListView: View {
  /// 인생샷 사진 리스트
  @Binding var images: [UserImage]
  /// 내 프로필뷰인지 체크
  let isMyPOTD: Bool
  /// 확대보기 여부
  @State var isShowingPOTDFull: Bool = false
  /// 확대보기 하기 위해 클릭한 사진 인덱스
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
    // 확대보기
    .fullScreenCover(isPresented: $isShowingPOTDFull) {
      POTDFullScreen($images, selectedIdx: selectedImageIdx, isMyPOTD: isMyPOTD)
    }
  }
}
