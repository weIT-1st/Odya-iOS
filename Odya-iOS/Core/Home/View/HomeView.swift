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
  @State private var placeInfo = PlaceInfo()
  @State private var showLocationSearchView: Bool = false
  @State private var showPlaceDetailView: Bool = false

  /// 내비게이션 스택 경로
  @State private var path = NavigationPath()
  
  // MARK: Body

  var body: some View {
    NavigationStack(path: $path) {
      ZStack(alignment: .top) {
        MapView()
          .edgesIgnoringSafeArea(.top)

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
            // TODO: 내 오댜 / 친구 오댜만 보기 버튼
          }
          .padding(.leading, 23)
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
          FeedDetailView(path: $path, communityId: communityId)
        case let.journalDetail(journalId):
          TravelJournalDetailView(journalId: journalId)
            .navigationBarHidden(true)
        }
      }
    }
  }
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
