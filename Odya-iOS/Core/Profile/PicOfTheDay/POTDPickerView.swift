//
//  POTDPicker.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

struct POTDRegisterModal: View {
  @Environment(\.dismiss) var dismiss
  let imageUrl: String
  //  let imageId: Int
  
  var body: some View {
    VStack(spacing: 20) {
      // image
      AsyncImage(url: URL(string: imageUrl)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(height: 207)
          .clipped()
          .cornerRadius(Radius.medium)
      } placeholder: {
        ProgressView()
          .frame(height: 207)
      }

      // place
      NavigationLink {
        // 장소 태그하기 뷰로 이동
      } label: {
        HStack(spacing: 12) {
          Image("location-m")
            .colorMultiply(Color.odya.label.assistive)
          Text("장소 태그하기")
            .detail1Style()
            .foregroundColor(Color.odya.label.assistive)
          Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 36)
        .background(Color.odya.elevation.elev4)
        .cornerRadius(Radius.small)
        .overlay(
          RoundedRectangle(cornerRadius: Radius.small)
            .inset(by: 0.5)
            .stroke(Color.odya.line.alternative, lineWidth: 1)
        )
      }
      
      // buttons
      HStack(spacing: 12) {
        CTAButton(isActive: .inactive,
                  buttonStyle: .basic,
                  labelText: "닫기",
                  labelSize: .S) {
          print("닫기")
          dismiss()
        }
        
        CTAButton(isActive: .active,
                  buttonStyle: .solid,
                  labelText: "등록하기",
                  labelSize: .S) {
          print("인생샷 등록")
          // TODO: 인생샷 등록 api
          dismiss()
        }
      }
    }
    .padding(.horizontal, 21)
    .padding(.top, 20)
    .padding(.bottom, 16)
    .frame(width: 335)
    .background(Color.odya.elevation.elev2)
    .cornerRadius(Radius.large)
  }
}

struct POTDPickerView: View {
  
  let images : [String] =
  ["https://image.tmdb.org/t/p/w500//r2J02Z2OpNTctfOSN1Ydgii51I3.jpg",
   "https://image.tmdb.org/t/p/w500//r2J02Z2OpNTctfOSN1Ydgii51I3.jpg"
  ]
  let totalWidth: CGFloat = UIScreen.main.bounds.width
  let spacing: CGFloat = 3
  let count: Int = 3
  var imageSize: CGFloat {
    return (totalWidth - ((CGFloat(count) - 1) * spacing)) / CGFloat(count)
  }
  var columns: [GridItem] {
    return Array(repeating: .init(.fixed(imageSize), spacing: spacing), count: count)
  }
  
  @State private var isShowingModal = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      
      VStack(spacing: 0) {
        CustomNavigationBar(title: "인생샷")
        ScrollView {
          LazyVGrid(columns: columns, spacing: 3) {
            ForEach(images, id: \.self) { imageUrl in
              Button(action: {
                isShowingModal = true
              }) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
                } placeholder: {
                  ProgressView()
                    .frame(width: imageSize, height: imageSize)
                }
              }.fullScreenCover(isPresented: $isShowingModal) {
                POTDRegisterModal(imageUrl: imageUrl)
                  .setModalBackground(Color.odya.background.dimmed_system)
              }
            }
          }
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
    }
  }
  
}

struct POTDPickerView_Previews: PreviewProvider {
  static var previews: some View {
    POTDPickerView()
  }
}
