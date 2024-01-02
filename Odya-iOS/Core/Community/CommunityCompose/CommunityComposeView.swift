//
//  CommunityComposeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/20.
//

import SwiftUI
import Photos

/// 커뮤니티 공개 타입
enum CommunityPrivacyType: String, CaseIterable {
  case global = "PUBLIC"
  case friendOnly = "FRIEND_ONLY"
  
  var description: String {
    switch self {
    case .global:
      return "전체공개"
    case .friendOnly:
      return "친구공개"
    }
  }
}

/// 커뮤니티 작성 모드
enum CommunityComposeMode {
  case create
  case edit
}

/// 커뮤니티 게시글 작성 뷰
struct CommunityComposeView: View {
  // MARK: Properties
  @Environment(\.presentationMode) var presentationMode
  
  /// 커뮤니티 아이디
  var communityId: Int = -1
  /// 게시글 텍스트
  @State var textContent: String = ""
  /// 공개범위
  @State var privacyType: CommunityPrivacyType = .global
  /// 장소 아이디
  // TODO: placeId
  /// 여행일지 아이디
  @State var travelJournalId: Int? = nil
  @State var travelJournalTitle: String? = nil
  /// 선택된 토픽 아이디
  @State var selectedTopicId: Int? = nil
  /// 기존 사진 url
  @State var originalImageList: [CommunityContentImage] = []
  /// 삭제할 이미지 아이디
  @State private var deleteImageIdList: [Int] = []
  /// 사진 피커 토글
  @State var showPhotoPicker: Bool = true
  
  /// 뷰모델
  @State private var viewModel = CommunityComposeViewModel()
  /// 추가할 사진 리스트
  @State private var imageList: [ImageData] = []
  /// 사진 접근 권한
  @State private var photoAccessStatus: PHAuthorizationStatus?

  /// 탭뷰 사진 인덱스
  @State private var imageIndex: Int = 0
  
  /// 화면 너비
  private let screenWidth = UIScreen.main.bounds.width
  /// 탭뷰 Dot indicator 높이
  private let dotIndicatorHeight: CGFloat = 44

  /// 내비게이션 스택 경로
  @Binding var path: NavigationPath
  /// 커뮤니티 작성 모드
  let composeMode: CommunityComposeMode
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 0) {
      // custom navigation bar
      navigationBar
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          // 사진
          ZStack(alignment: .bottom) {
            // tabview
            TabView(selection: $imageIndex) {
              // 기존 등록된 이미지
              ForEach(0..<originalImageList.count, id: \.self) { index in
                VStack(spacing: 0) {
                  SquareAsyncImage(url: originalImageList[index].imageURL)
                  Spacer()
                }
                .tag(index)
              }
              
              // 생성
              if composeMode == .create && imageList.isEmpty {
                Image("logo-rect")
                  .frame(width: screenWidth, height: screenWidth)
              } else {
                ForEach(0..<imageList.count, id: \.self) { index in
                  VStack(spacing: 0) {
                    Image(uiImage: imageList[index].image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: screenWidth, height: screenWidth, alignment: .center)
                      .clipped()
                    Spacer()
                  }
                  .tag(originalImageList.count + index)
                }
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
            TopicGridView(selectedTopic: $selectedTopicId)
            
            // 공개여부
            Text("공개 여부")
              .h6Style()
              .foregroundColor(Color.odya.label.normal)
            privacyTypeToggle
          }
          .padding(.horizontal, GridLayout.side)
          .padding(.bottom, 20)
          
          // 작성완료 버튼
          CTAButton(isActive: validate() ? .active : .inactive,
                    buttonStyle: .solid,
                    labelText: composeMode == .create ? "작성완료" : "수정완료",
                    labelSize: .L) {
            switch composeMode {
            case .create:
              viewModel.createCommunity(content: textContent, visibility: privacyType.rawValue, placeId: nil, travelJournalId: travelJournalId, topicId: selectedTopicId, imageData: imageList)
            case .edit:
              viewModel.updateCommunity(communityId: communityId, content: textContent, visibility: privacyType.rawValue, placeId: nil, travelJournalId: travelJournalId, topicId: selectedTopicId, deleteImageIds: deleteImageIdList, updateImageData: imageList)
              break
            }

            presentationMode.wrappedValue.dismiss()
          }
          .padding(.bottom, 22)
          .disabled(!validate())  // 사진 or 내용이 없으면 비활성화
        }
      }  // ScrollView
      .background(Color.odya.background.normal)
    }  // VStack
    .toolbar(.hidden)
    .onAppear {
      PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        self.photoAccessStatus = status
      }
    }
    .sheet(isPresented: $showPhotoPicker) {
      PhotoPickerView(imageList: $imageList, accessStatus: photoAccessStatus ?? .notDetermined)
    }
  }
  
  func validate() -> Bool {
    if (imageList.isEmpty && originalImageList.isEmpty) || textContent == "" {
      return false
    } else {
      return true
    }
  }
  
  private var navigationBar: some View {
    ZStack(alignment: .center) {
      CustomNavigationBar(title: "피드 작성하기")
      HStack {
        Spacer()
        Button {
          showPhotoPicker.toggle()
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
    NavigationLink {
      LinkedTravelJournalView(path: $path, selectedJournalId: $travelJournalId, selectedJournalTitle: $travelJournalTitle)
    } label: {
      ZStack {
        HStack(alignment: .center, spacing: 16) {
          Image("diary")
            .resizable()
            .frame(width: 24, height: 24)
          Text(travelJournalTitle != nil ? travelJournalTitle! : "여행일지 불러오기")
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
        
        HStack {
          Spacer()
          Circle()
            .fill(Color.odya.brand.primary)
            .frame(width: 48, height: 48)
            .overlay(Image("arrow-up-right"))
        }
      }
      .padding(.horizontal, 48)
    }
  }
  
  /// 게시글 작성 텍스트필드
  private var contentEditView: some View {
    HStack(alignment: .top, spacing: 12) {
      Image("pen-s")
        .colorMultiply(Color.odya.label.assistive)
      
      TextField("글 작성하기 (최대 200 자)", text: $textContent, axis: .vertical)
        .b1Style()
        .foregroundColor(Color.odya.label.normal)
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
  
  /// 공개타입 토글
  private var privacyTypeToggle: some View {
    ZStack(alignment: .center) {
      GeometryReader { proxy in
        RoundedRectangle(cornerRadius: 50)
          .fill(Color.odya.brand.primary)
          .frame(height: 36)
          .frame(maxWidth: proxy.size.width / 2)
          .offset(x: privacyType == .global ? 0 : proxy.size.width / 2 - 4)
          .padding(2)
      } // GeometryReader
      
      HStack(spacing: 0) {
        ForEach(CommunityPrivacyType.allCases, id: \.self) { privacy in
          VStack {
            Text(privacy.description)
              .b1Style()
              .foregroundColor(privacyType == privacy ? .odya.label.r_normal : .odya.label.inactive)
          }
          .frame(height: 36)
          .frame(maxWidth: .infinity)
          .onTapGesture {
            withAnimation(.linear) {
              privacyType = privacy
            }
          }
          .frame(maxWidth: .infinity)
        }
      } // HStack
      
    } // ZStack
    .background(
      RoundedRectangle(cornerRadius: 50)
        .foregroundColor(.odya.elevation.elev5)
    )
    .frame(height: 40)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 24)
  }
}

// MARK: - Previews
//struct CommunityComposeView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommunityComposeView(composeMode: .edit)
//  }
//}
