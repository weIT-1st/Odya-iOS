//
//  FeedDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedDetailView: View {
    // MARK: Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: -16) {
                // images
                Image("logo-rect")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width)
                    .background(.blue)
                
                // -- content --
                VStack(spacing: 8) {
                    VStack(spacing: 20) {
                        FeedUserInfoView()
                            .padding(.top, 16)
                            .padding(.horizontal, GridLayout.side)
                        
                        VStack(spacing: 24) {
                            // TODO: travel journal cover
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.white)
                                .frame(height: 100)
                            
                            // feed text
                            Text("오늘 졸업 여행으로 오이도에 다녀왔어요! 생각보다 추웠지만 너무 재밌었습니다! 맛있는 회도 먹고 친구들과 좋은 시간도 보내고 왔습니다 ㅎㅎ 다들 졸업 축하해 ~ 어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구어쩌구 저쩌구")
                                .detail2Style()
                            //                            .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, GridLayout.side)
                        
                        VStack(spacing: 16) {
                            // tags
                            // TODO: scroll view
                            HStack {
                                FishchipButton(isActive: .inactive, buttonStyle: .solid, imageName: nil, labelText: "# 추억팔이", labelSize: .M) {
                                    // action
                                }
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
                                    HStack(spacing: 0) {
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
                
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton(),
                                trailing: FeedShareButton())
        } // ScrollView
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

struct FeedShareButton: View {
    var body: some View {
        IconButton("share") {
            // TODO: action - share
        }
    }
}

// MARK: - Preview

struct FeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FeedDetailView()
    }
}
