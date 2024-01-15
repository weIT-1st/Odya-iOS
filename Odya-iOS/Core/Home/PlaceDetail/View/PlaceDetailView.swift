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
  @Binding var path: NavigationPath
  
  @StateObject var viewModel = PlaceDetailViewModel()
  @State var showReviewComposeView: Bool = false
  @State var scrollDestination: PlaceDetailContentType = .journal
  @State var isScrollDestinationChanged: Bool = false
  
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
              overview
                .id(PlaceDetailContentType.journal)
              VStack(spacing: 48) {
                travelJournalPart
                Divider()
                  .padding(.horizontal, GridLayout.side)
                  .id(PlaceDetailContentType.review)
                reviewPart
                Divider()
                  .padding(.horizontal, GridLayout.side)
                  .id(PlaceDetailContentType.community)
                communityPart
              }
              .padding(.vertical, 24)
              
            } header: {
              bottomSheetIndicator
            }
          }
        } // ScrollView
        .clipShape(RoundedEdgeShape(edgeType: .top))
        .onChange(of: isScrollDestinationChanged) { _ in
          switch scrollDestination {
          case .journal:
            withAnimation {
              proxy.scrollTo(scrollDestination, anchor: .bottom)
            }
          default:
            withAnimation {
              proxy.scrollTo(scrollDestination, anchor: .top)
            }
          }
        }
        .background(Color.odya.background.normal)
        .toolbar(.hidden)
      }
      .frame(maxWidth: .infinity)
      .sheet(isPresented: $showReviewComposeView) {
        ReviewComposeView(isPresented: $showReviewComposeView, placeId: $placeInfo.placeId)
          .presentationDetents([.medium])
          .presentationDragIndicator(.visible)
      }
      .task {
        viewModel.fetchPlaceImage(placeId: placeInfo.placeId, token: placeInfo.sessionToken)
        viewModel.fetchVisitingUser(placeId: placeInfo.placeId)
        viewModel.fetchReviewInfo(placeId: placeInfo.placeId)
        viewModel.fetchAllFeedByPlaceNextPageIfPossible(placeId: placeInfo.placeId)
      }
    }
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        withAnimation {
          isPresented = false
        }
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
        if count > 0 {
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
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }
  
  /// 장소 사진, 이름, 주소, 다녀간 친구, 관심장소 설정 버튼 포함
  private var overview: some View {
    ZStack(alignment: .bottomTrailing) {
      if let photo = viewModel.placeImage {
        Image(uiImage: photo)
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
      } else {
        ProgressView()
          .frame(maxWidth: .infinity)
          .frame(height: UIScreen.main.bounds.width * 0.586)
      }

      VStack(spacing: 6) {
        visitorView
        Spacer()
        Text(placeInfo.title)
          .h4Style()
          .foregroundColor(.odya.label.normal)
          .frame(maxWidth: .infinity)
        Text(placeInfo.address)
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(maxWidth: .infinity)
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
  }
}

// MARK: - Previews
struct PlaceDetailView_Previews: PreviewProvider {
  var placeInfo = PlaceInfo()
  
  static var previews: some View {
    PlaceDetailView(isPresented: .constant(true), path: .constant(NavigationPath()))
      .environmentObject(PlaceInfo())
      .background(.green)
  }
}
