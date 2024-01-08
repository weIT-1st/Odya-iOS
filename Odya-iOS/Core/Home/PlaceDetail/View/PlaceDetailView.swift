//
//  PlaceDetailView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/06.
//

import SwiftUI

enum PlaceDetailContentType: Int, CaseIterable {
  case journal
  case review
  case community
  
  var title: String {
    switch self {
    case .journal:
      return "여행일지"
    case .review:
      return "한줄리뷰"
    case .community:
      return "커뮤니티"
    }
  }
}

/// 장소 상세보기 뷰
struct PlaceDetailView: View {
  // MARK: Properties
  @EnvironmentObject var placeInfo: PlaceInfo
  @Binding var isPresented: Bool
  
  @StateObject private var viewModel = PlaceDetailViewModel()
  @State private var showReviewComposeView: Bool = false
  @State private var scrollDestination: PlaceDetailContentType = .journal
  
  /// Grid columns
  var columns = [GridItem(.flexible(), spacing: 3),
                 GridItem(.flexible(), spacing: 3),
                 GridItem(.flexible())]
  
  // MARK: Body
  var body: some View {
    VStack(spacing: 24) {
      navigationBar
      
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
              // travel journal
              PlaceDetailContentTypeSelection(contentType: .journal, destination: $scrollDestination)
                .id(PlaceDetailContentType.journal)
              
              // review
              PlaceDetailContentTypeSelection(contentType: .review, destination: $scrollDestination)
                .id(PlaceDetailContentType.review)
              
              VStack(spacing: 16) {
                Text("\(placeInfo.title)의 방문 경험은 어떠셨나요?")
                  .detail2Style()
                  .foregroundColor(.odya.label.normal)
                CTAButton(isActive: .active, buttonStyle: .ghost, labelText: "리뷰 작성", labelSize: .L) {
                  showReviewComposeView.toggle()
                }
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 24)
              .frame(maxWidth: .infinity)
              .background(Color.odya.elevation.elev4)
              
              // community
              PlaceDetailContentTypeSelection(contentType: .community, destination: $scrollDestination)
                .id(PlaceDetailContentType.community)
              
              LazyVGrid(columns: columns, spacing: 3) {
                ForEach(viewModel.feedState.content, id: \.communityID) { content in
                  // 1:1 ratio image
                  Color.clear.overlay(
                    AsyncImage(url: URL(string: content.communityMainImageURL)!) { phase in
                      switch phase {
                      case .success(let image):
                        image
                          .resizable()
                          .scaledToFill()
                      default:
                        ProgressView()
                      }
                    }
                  )
                  .frame(maxWidth: .infinity)
                  .aspectRatio(1, contentMode: .fit)
                  .clipped()
                  .onAppear {
                    // 다음 페이지 불러오기
                    if content.communityID == viewModel.feedState.lastId {
                      viewModel.fetchAllFeedByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
                    }
                  }
                }
              }

            } header: {
              bottomSheetIndicator
            }
          }
          
        } // ScrollView
        .clipShape(RoundedEdgeShape(edgeType: .top))
        .onChange(of: scrollDestination) { newValue in
          proxy.scrollTo(scrollDestination)
        }
        .background(Color.odya.background.normal)
      }
    }
    .frame(maxWidth: .infinity)
    .sheet(isPresented: $showReviewComposeView) {
      ReviewComposeView(isPresented: $showReviewComposeView, placeId: $placeInfo.placeId)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    .task {
      viewModel.fetchAllFeedByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
    }
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        isPresented = false
      } label: {
        Image("direction-left")
          .frame(width: 36, height: 36)
      }
      Spacer()
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
  }
  
  private var bottomSheetIndicator: some View {
    VStack {
      Capsule()
        .foregroundColor(.odya.label.assistive)
        .frame(width: 80, height: 4)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 34)
    .background(Color.odya.background.normal)
  }
  
}

struct PlaceDetailContentTypeSelection: View {
  let contentType: PlaceDetailContentType
  @Binding var destination: PlaceDetailContentType

  var body: some View {
    ZStack(alignment: .center) {
      GeometryReader { proxy in
        RoundedRectangle(cornerRadius: 50)
          .fill(Color.odya.brand.primary)
          .frame(height: 36)
          .frame(maxWidth: proxy.size.width / 3)
          .offset(x: contentType == .journal ? 0 : contentType == .review ? proxy.size.width / 3 - 4 : proxy.size.width / 3 * 2 - 4)
          .padding(2)
      } // GeometryReader
      
      HStack(spacing: 0) {
        ForEach(PlaceDetailContentType.allCases, id: \.self) { type in
          VStack {
            Text(type.title)
              .b1Style()
              .foregroundColor(contentType == type ? .odya.label.r_normal : .odya.label.inactive)
          }
          .frame(height: 36)
          .frame(maxWidth: .infinity)
          .onTapGesture {
            destination = type
          }
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
struct PlaceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailView(isPresented: .constant(true))
      .environmentObject(PlaceInfo())
      .background(.green)
  }
}
