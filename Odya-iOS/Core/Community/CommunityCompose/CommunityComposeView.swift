//
//  CommunityComposeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/20.
//

import SwiftUI

/// 커뮤니티 게시글 작성 뷰
struct CommunityComposeView: View {
    // MARK: Properties
    
    /// 탭뷰 사진 인덱스
    @State private var imageIndex: Int = 0
    /// 게시글 텍스트
    @State private var textContent: String = ""
    /// 탭뷰 Dot indicator 높이
    private let dotIndicatorHeight: CGFloat = 44
    
    /// 테스트 이미지 주소
    let testImageUrlString =
      "https://plus.unsplash.com/premium_photo-1680127400635-c3db2f499694?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60"
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // custom navigation bar
            navigationBar
            
            ScrollView {
                VStack(spacing: 0) {
                    // 사진
                    ZStack(alignment: .bottom) {
                        // tabview
                        TabView(selection: $imageIndex) {
                            ForEach(0..<5) { index in
                                VStack(spacing: 0) {
                                    SquareAsyncImage(url: testImageUrlString)
                                    Spacer()
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: UIScreen.main.bounds.width + dotIndicatorHeight, alignment: .top)
                        
                        // 여행일지 연결 버튼
                        connectTravelJournalButton
                            .padding(.bottom, dotIndicatorHeight + 30)
                    }
                    
                    VStack(alignment: .leading, spacing: GridLayout.spacing) {
                        // 게시글 작성
                        Text("게시글 작성하기")
                            .h6Style()
                            .foregroundColor(Color.odya.label.normal)
                        
                        VStack(spacing: 12) {
                            contentEditView
                            placeTagLink
                        }

                        // 토픽
                        Text("토픽")
                            .h6Style()
                            .foregroundColor(Color.odya.label.normal)
                        TopicGridView()
                        
                    }
                    .padding(.horizontal, GridLayout.side)
                    .padding(.bottom, 20)
                    
                    // 작성완료 버튼
                    CTAButton(isActive: .active, buttonStyle: .solid, labelText: "작성완료", labelSize: .L) {
                        // action: 여행일지 생성
                    }
                    .padding(.bottom, 22)
                }
            } // ScrollView
        } // VStack
        .toolbar(.hidden)
    }
    
    private var navigationBar: some View {
        ZStack(alignment: .center) {
            CustomNavigationBar(title: "피드 작성하기")
            HStack {
                Spacer()
                NavigationLink {
                    // action: 이미지 피커 열기
                } label: {
                    Text("사진편집")
                        .b1Style()
                        .foregroundColor(Color.odya.label.assistive)
                }
            }
            .padding(.trailing, 12)
        }
    }
    
    /// 여행일지 불러오기 버튼
    private var connectTravelJournalButton: some View {
        ZStack {
            HStack(alignment: .center, spacing: 16) {
                Image("diary")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("여행일지 불러오기")
                    .b1Style()
                    .foregroundColor(Color.odya.label.normal)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 22)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(Color.odya.background.dimmed_system)
            .cornerRadius(100)
            
            Button {
                // action: 여행일지 불러오기
            } label: {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.odya.brand.primary)
                        .frame(width: 48, height: 48)
                        .overlay(Image("arrow-up-right"))
                }
            }
        }
        .padding(.horizontal, 48)
    }
    
    /// 게시글 작성 텍스트필드
    private var contentEditView: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("pen-s")
                .colorMultiply(Color.odya.label.assistive)
            
            TextField("글 작성하기 (최대 200 자)", text: $textContent, axis: .vertical)
                .b1Style()
                .foregroundColor(textContent.isEmpty ? Color.odya.label.assistive : Color.odya.label.normal)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(height: 158, alignment: .top)
        .background(Color.odya.elevation.elev4)
        .cornerRadius(Radius.medium)
        .overlay(
          RoundedRectangle(cornerRadius: Radius.medium)
            .inset(by: 0.5)
            .stroke(Color.odya.line.alternative, lineWidth: 1)
        )
    }
    
    /// 장소 태그하기 내비게이션 링크
    private var placeTagLink: some View {
        NavigationLink {
            // 장소 태그하기 뷰로 이동
        } label: {
            HStack(spacing: 12) {
                Image("location-m")
                    .colorMultiply(Color.odya.label.assistive)
                Text("장소 태그하기")
                    .b1Style()
                    .foregroundColor(Color.odya.label.assistive)
                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.odya.elevation.elev4)
            .cornerRadius(Radius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.medium)
                    .inset(by: 0.5)
                    .stroke(Color.odya.line.alternative, lineWidth: 1)
            )
        }
    }
}

// MARK: - Previews
struct CommunityComposeView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityComposeView()
    }
}
