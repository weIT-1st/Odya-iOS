//
//  FeedDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedDetailView: View {
  // MARK: Properties

  let testImageUrlString =
    "https://plus.unsplash.com/premium_photo-1680127400635-c3db2f499694?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60"

  // MARK: Body

  var body: some View {
    ScrollView {
      VStack(spacing: -16) {
        // images
        AsyncImage(
          url: URL(string: testImageUrlString)!,
          content: { image in
            image.resizable()
              .aspectRatio(contentMode: .fill)
              .clipped()
          },
          placeholder: {
            ProgressView()
          }
        )
        .frame(
          width: UIScreen.main.bounds.width,
          height: UIScreen.main.bounds.width)

        // -- content --
        VStack(spacing: 8) {
          VStack(spacing: 20) {
            HStack(alignment: .center) {
              FeedUserInfoView(profileImageSize: ComponentSizeType.XS.ProfileImageSize)

              Spacer()

              // 팔로우버튼
              FollowButton(isFollowing: false, buttonStyle: .ghost) {
                // follow
              }
            }
            .padding(.top, 16)
            .padding(.horizontal, GridLayout.side)

            VStack(spacing: 24) {
              // 여행일지
              JournalCoverButton(
                profileImageUrl: nil,
                labelText: "여행일지 더보기",
                coverImageUrl: URL(string: testImageUrlString)!,
                journalTitle: "2020 컴공과 졸업여행",
                isHot: true
              ) {
                // action
              }

              // feed text
              Text(
                "오늘 졸업 여행으로 오이도에 다녀왔어요! 생각보다 추웠지만 너무 재밌었습니다! 맛있는 회도 먹고 친구들과 좋은 시간도 보내고 왔습니다 ㅎㅎ 다들 졸업 축하해 ~ 어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구"
              )
              .detail2Style()
              //                            .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, GridLayout.side)

            VStack(spacing: 16) {
              // tags
              ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                  FishchipButton(
                    isActive: .active, buttonStyle: .ghost, imageName: nil, labelText: "# 추억팔이",
                    labelSize: .S
                  ) {
                    // action
                  }
                }
                .padding(.horizontal, GridLayout.side)
              }

              // location, comment, heart button
              HStack {
                // location
                HStack(spacing: 4) {
                  Image("location-m")
                    .renderingMode(.template)
                    .foregroundColor(Color.odya.label.assistive)
                    .frame(width: 24, height: 24)
                  // 장소명
                  Text("오이도오이도오이도오이도오이도오이도오이도")
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .detail2Style()
                    .foregroundColor(Color.odya.label.assistive)
                }

                Spacer(minLength: 28)

                HStack(spacing: 12) {
                  HStack(spacing: 4) {
                    Image("comment")
                      .frame(width: 24, height: 24)
                    // number of comment
                    Text("99+")
                      .detail1Style()
                      .foregroundColor(Color.odya.label.normal)
                  }
                  HStack(spacing: 4) {
                    Image("heart-off-m")
                      .frame(width: 24, height: 24)
                    // number of heart
                    Text("99+")
                      .detail1Style()
                      .foregroundColor(Color.odya.label.normal)
                  }
                }
              }
              .frame(maxWidth: .infinity)
              .padding(.horizontal, 18)
              .padding(.vertical, 8)
            }
          }
          .frame(maxWidth: .infinity)

          // -- comment --
          FeedCommentView()
        }
        .background(Color.odya.background.normal)
        .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))

      }  // VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationBarBackButtonHidden(true)
      .navigationBarItems(
        leading: CustomBackButton(),
        trailing: FeedMenuButton())
    }  // ScrollView
    .edgesIgnoringSafeArea(.top)
  }
}

// MARK: - CustomBackButton

struct CustomBackButton: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    IconButton("direction-left") {
      dismiss()
    }
    .frame(width: 36, height: 36, alignment: .center)
  }
}

// MARK: - FeedShareButton

struct FeedMenuButton: View {
  @State private var showActionSheet = false

  var body: some View {
    IconButton("menu-kebab-l") {
      showActionSheet.toggle()
    }
    .frame(width: 36, height: 36, alignment: .center)
    .confirmationDialog("", isPresented: $showActionSheet) {
      Button("공유") {
        // action: 공유
      }
      Button("신고하기", role: .destructive) {
        // action: 신고
      }
    }
  }
}

// MARK: - Preview

struct FeedDetailView_Previews: PreviewProvider {
  static var previews: some View {
    FeedDetailView()
  }
}
