//
//  POTDPicker.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

/// 인생샷 고를 수 있는 페이지
/// 피드 및 여행일지에 올렸던 사진들 중 인생샷을 고를 수 있음
struct POTDPickerView: View {
  @StateObject var VM = POTDViewModel()

  // 이미지 그리드 뷰에 사용되는 값
  let totalWidth: CGFloat = UIScreen.main.bounds.width
  let spacing: CGFloat = 3
  let count: Int = 3
  var imageSize: CGFloat {
    return (totalWidth - ((CGFloat(count) - 1) * spacing)) / CGFloat(count)
  }
  var columns: [GridItem] {
    return Array(repeating: .init(.fixed(imageSize), spacing: spacing), count: count)
  }

  /// 선택된 이미지에 대해 등록 모달이 화면에 표시되는지 여부
  @State private var isShowingModal = false

  // MARK: Body

  var body: some View {
    ZStack(alignment: .bottom) {
      Color.odya.background.normal.ignoresSafeArea()

      VStack(spacing: 0) {
        CustomNavigationBar(title: "인생샷")

        ScrollView {
          LazyVGrid(columns: columns, spacing: 3) {
            ForEach(VM.userImageList, id: \.id) { image in
              self.getImageTile(image)
                // 무한스크롤
                .onAppear {
                  if let last = VM.userImageList.last,
                    last.imageId == image.imageId
                  {
                    VM.fetchMoreSubject.send()
                  }
                }

            }  // ForEach
          }  // LazyVGrid
        }  // ScrollView

      }  // VStack

      // 유저 이미지 리스트가 비어있을 때, 로딩 표시
      if VM.userImageList.isEmpty {
        VStack {
          Spacer()
          ProgressView()
          Spacer()
        }
      }

      Text("여행일지 및 커뮤니티에서 작성된 이미지입니다")
        .b1Style()
        .foregroundColor(.odya.label.normal)
        .frame(height: 12)
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .background(Color.odya.background.dimmed_system)
        .cornerRadius(Radius.large)
        .offset(y: -40)
    }  // ZStack
    // 인생샷 등록 모달
    .fullScreenCover(isPresented: $isShowingModal) {
      POTDRegisterModal(image: VM.selectedImage!)
        .setModalBackground(Color.odya.background.dimmed_system)
        .environmentObject(VM)
    }
  }  // body
}

// MARK: Image Tile
extension POTDPickerView {

  /// 이미지 그리드 뷰에서 그려지는 하나의 이미지 타일
  /// 클릭 시 해당 이미지에 대해 등록 모달을 띄워줌
  private func getImageTile(_ image: UserImage) -> some View {
    return Button(action: {
      VM.selectedImage = image
      if VM.selectedImage != nil {
        isShowingModal = true
      }
    }) {
      AsyncImageView(
        url: image.imageUrl,
        width: imageSize, height: imageSize,
        cornerRadius: 0)
    }
  }
}

struct POTDPickerView_Previews: PreviewProvider {
  static var previews: some View {
    POTDPickerView()
  }
}
