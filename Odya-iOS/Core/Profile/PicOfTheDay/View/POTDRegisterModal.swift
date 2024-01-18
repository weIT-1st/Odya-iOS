//
//  POTDRegisterModal.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import SwiftUI

/// 인생샷 등록 모달
/// 선택된 이미지에 대해 장소 태그 및 인생샷 등록을 할 수 있음
struct POTDRegisterModal: View {
  @EnvironmentObject var VM: POTDViewModel
  @Environment(\.dismiss) var dismiss

  let image: UserImage
  var imageId: Int { image.imageId }
  var imageUrl: String { image.imageUrl }
  @State private var placeName: String?
  
  /// 장소 태그하기 뷰 풀스크린 표시 여부
  @State private var showPlaceTagView: Bool = false
  
  init(image: UserImage) {
    self.image = image
    self.placeName = image.placeName
  }

  // MARK: Body
  var body: some View {
    VStack(spacing: 20) {
      imageView

      placeTagButton

      HStack(spacing: 12) {
        cancelButton
        registerButton
      }
    }
    .padding(.horizontal, 21)
    .padding(.top, 20)
    .padding(.bottom, 16)
    .frame(width: 335)
    .background(Color.odya.elevation.elev2)
    .cornerRadius(Radius.large)
  }

  // MARK: Image View
  private var imageView: some View {
    AsyncImageView(
      url: imageUrl,
      width: 292, height: 207,
      cornerRadius: Radius.medium)
  }

  // MARK: Place Tag Button
  private var placeTagButton: some View {
    // TODO: 인생샷은 PlaceId가 아니라 PlaceName을 저장
    PlaceTagButtonWithAction(placeId: placeName) {
      showPlaceTagView.toggle()
    }
    .fullScreenCover(isPresented: $showPlaceTagView) {
      PlaceTagView(placeId: $placeName)
    }
  }

  // MARK: Cancel Button
  private var cancelButton: some View {
    CTAButton(
      isActive: .inactive,
      buttonStyle: .basic,
      labelText: "닫기",
      labelSize: .S
    ) {
      dismiss()
    }
  }

  // MARK: Register Button
  private var registerButton: some View {
    CTAButton(
      isActive: .active,
      buttonStyle: .solid,
      labelText: "등록하기",
      labelSize: .S
    ) {
      VM.registerPOTD(imageId: imageId, placeName: placeName)
      dismiss()
    }

  }
}
