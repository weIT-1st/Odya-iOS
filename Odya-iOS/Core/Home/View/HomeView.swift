//
//  HomeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/23.
//

import SwiftUI

enum PlaceDetailRoute: Hashable {
  case feedDetail(id: Int)
  case journalDetail(id: Int)
}

struct HomeView: View {
  // MARK: Properties
  @StateObject private var viewModel = HomeViewModel()
  
  @State private var placeInfo = PlaceInfo()
  @State private var showLocationSearchView: Bool = false
  @State private var showPlaceDetailView: Bool = false

  /// 내비게이션 스택 경로
  @State private var path = NavigationPath()
  
  // MARK: Body

  var body: some View {
    NavigationStack(path: $path) {
      ZStack(alignment: .top) {
        HomeMapView()
          .environmentObject(viewModel)
          .edgesIgnoringSafeArea(.top)
          .onReceive(viewModel.selectedPlaceId) { placeId in
            placeInfo.setValue(placeId: placeId)
            withAnimation {
              showPlaceDetailView = true
            }
          }

        if showLocationSearchView {
          Color.odya.blackopacity.baseBlackAlpha50
            .onTapGesture {
              showLocationSearchView.toggle()
            }
          LocationSearchView(isPresented: $showLocationSearchView, showPlaceDetail: $showPlaceDetailView)
            .environmentObject(placeInfo)
        } else if !showPlaceDetailView {
          HStack {
            LocationSearchActivationView()
              .onTapGesture {
                showLocationSearchView = true
              }
            Spacer()
            imageTypeToggle(selection: viewModel.selectedImageUserType) {
              viewModel.selectedImageUserType = viewModel.selectedImageUserType.getNext()
            }
          }
          .padding(.leading, 23)
          .padding(.trailing, 16)
        }
        
        if showPlaceDetailView {
          PlaceDetailView(isPresented: $showPlaceDetailView, path: $path)
            .environmentObject(placeInfo)
            .transition(.move(edge: .bottom))
            .zIndex(1)
        }
      }
      .navigationDestination(for: PlaceDetailRoute.self) { route in
        switch route {
        case let .feedDetail(communityId):
          FeedDetailView(communityId: communityId)
        case let.journalDetail(journalId):
          TravelJournalDetailView(journalId: journalId)
            .navigationBarHidden(true)
        }
      }
    }
  }
  
  private func imageTypeToggle(selection: ImageUserType, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(selection.getNext() == .user ? "내 오댜만 보기" : "친구 오댜도 보기")
        .detail1Style()
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .foregroundColor(selection.getNext() == .user ?
                        .odya.brand.primary : .odya.background.normal)
        .background(selection.getNext() == .user ?
                    Color.odya.background.normal : Color.odya.brand.primary)
    }
    .clipShape(Capsule())
  }
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
