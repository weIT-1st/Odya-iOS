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
              
              ZStack(alignment: .bottomTrailing) {
                Image("photo_example 1")
                  .resizable()
                  .frame(maxWidth: .infinity)
                  .frame(height: UIScreen.main.bounds.width * 0.586)
                  .overlay(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0.22),
                        Gradient.Stop(color: .black.opacity(0.7), location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0.5, y: 0),
                      endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                  )
                VStack(spacing: 6) {
                  visitorView
                  Spacer()
                  Text("해운대 해수욕장")
                    .h4Style()
                    .foregroundColor(.odya.label.normal)
                  Text("부산 해운대구 우동")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
                }
                .padding(.bottom, 20)
                Button {
                  // action: 관심장소 설정/해제
                } label: {
                  Image("bookmark-off")
                }
                .padding(.trailing, 41)
                .padding(.bottom, 31)
              }
              
              VStack(spacing: 48) {
                // MARK: travel journal
                VStack(spacing: 28) {
                  PlaceDetailContentTypeSelection(contentType: .journal, destination: $scrollDestination)
                    .id(PlaceDetailContentType.journal)
                  VStack(spacing: 48) {
                    VStack(spacing: 36) {
                      HStack {
                        Text("나의 여행일지")
                          .h4Style()
                          .foregroundColor(.odya.label.normal)
                        Spacer()
                      }
                    }
                    VStack(spacing: 36) {
                      HStack {
                        Text("친구의 여행일지")
                          .h4Style()
                          .foregroundColor(.odya.label.normal)
                        Spacer()
                      }
                    }
                    VStack(spacing: 36) {
                      HStack {
                        Text("추천 여행일지")
                          .h4Style()
                          .foregroundColor(.odya.label.normal)
                        Spacer()
                      }
                    }
                  }
                  .padding(.horizontal, GridLayout.side)
                }

                Divider()
                  .padding(.horizontal, GridLayout.side)
                
                // MARK: review
                VStack(spacing: 28) {
                  PlaceDetailContentTypeSelection(contentType: .review, destination: $scrollDestination)
                    .id(PlaceDetailContentType.review)
                  
                  VStack(spacing: 24) {
                    VStack(spacing: 36) {
                      HStack {
                        HStack(spacing: 8) {
                          Text("한줄리뷰")
                            .h5Style()
                            .foregroundColor(.odya.label.normal)
                          Text("3.0")
                            .b2Style()
                            .foregroundColor(.odya.label.assistive)
                        }
                        Spacer()
                        HStack(spacing: 8) {
                          Text("리뷰 총")
                            .b1Style()
                            .foregroundColor(.odya.label.normal)
                          HStack(spacing: 4) {
                            Text("20")
                              .b2Style()
                              .foregroundColor(.odya.brand.primary)
                            Text("개")
                              .b1Style()
                              .foregroundColor(.odya.label.normal)
                          }
                        }
                      }
                      .padding(.horizontal, GridLayout.side)
                      StarRatingView(rating: .constant(3.0))
                        .disabled(true)
                    } // header
                    
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
                    
                    // 정렬
                  }
                }
                
                Divider()
                
                // MARK: Community
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
              }
              .padding(.vertical, 24)
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
      viewModel.fetchVisitingUser(placeId: placeInfo.placeId)
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
  
  private var visitorView: some View {
    VStack {
      if let count = viewModel.visitorCount {
        HStack {
          HStack(spacing: 16) {
            Image("odya-logo-s")
            Text("내 친구 \(count)명이 다녀갔어요!")
              .detail1Style()
              .foregroundColor(.odya.label.normal)
          }
          Spacer()
          HStack(spacing: -4) {
            ForEach(viewModel.visitorList.prefix(3), id: \.id) { visitor in
              ProfileImageView(of: "", profileData: visitor.profile, size: .S)
            }
          }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.odya.background.dimmed_system)
        .cornerRadius(Radius.medium)
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }
}

// MARK: - Previews
struct PlaceDetailView_Previews: PreviewProvider {
  var placeInfo = PlaceInfo()
  
  static var previews: some View {
    PlaceDetailView(isPresented: .constant(true))
      .environmentObject(PlaceInfo())
      .background(.green)
  }
}
