//
//  PlaceTagView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI
import GoogleMaps

/// 장소 태그하기 뷰
struct PlaceTagView: View {
  // MARK: Properties
  
  @StateObject private var viewModel = PlaceTagViewModel()
  @Binding var placeId: String?    // 장소ID
  let bottomSheetMaxHeight = (UIScreen.main.bounds.height - 56) / 2 - 34 * 2
  
  // MARK: Body
  
  var body: some View {
    VStack(spacing: 0) {
      // custom navigation bar
      navigationBar
      
      GeometryReader { proxy in
//        let height = proxy.frame(in: .local).height
        VStack(spacing: -34) {
          // map
          ZStack(alignment: .bottomTrailing) {
            PlaceTagMapView(markers: $viewModel.markers, selectedMarker: $viewModel.selectedMarker, bounds: $viewModel.bounds)
            Button {
              // action: current location
            } label: {
              Circle()
                .foregroundColor(.odya.background.normal)
                .frame(width: 36, height: 36)
                .overlay(
                  Image("gps")
                    .renderingMode(.template)
                    .foregroundColor(.odya.brand.primary)
                )
            }
            .padding(.bottom, 34 + 14)
            .padding(.horizontal, GridLayout.side)
          }
//          .frame(maxHeight: .infinity)
          VStack(spacing: 0) {
            bottomSheetIndicator
            PlaceTagSearchView(placeId: $placeId)
              .environmentObject(viewModel)
          }
          .padding(.horizontal, GridLayout.side)
          .background(Color.odya.background.normal)
          .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: 24))
          .frame(height: bottomSheetMaxHeight)
          .frame(minHeight: 44, maxHeight: bottomSheetMaxHeight)
        }
      }
    }
    .toolbar(.hidden)
    .background(Color.odya.background.normal)
  }
  
  /// custom navigation bar
  private var navigationBar: some View {
    ZStack {
      CustomNavigationBar(title: "장소 태그하기")
      HStack {
        Spacer()
        Button {
          // action - 완료
        } label: {
          Text("완료")
            .b1Style()
            .foregroundColor(self.placeId == nil ? Color.odya.label.assistive : Color.odya.label.normal)
            .padding(.horizontal, 4)
        }
        .disabled(self.placeId == nil ? true : false)
      }
      .padding(.trailing, 12)
    }
  }
  
  private var bottomSheetIndicator: some View {
    Capsule()
      .fill(Color.odya.label.normal)
      .frame(width: 134, height: 5)
      .padding(.top, 21)
      .padding(.bottom, 8)
  }
}

//struct PlaceTagBottomSheet: View {
//  /// Gesture
//  @State var offset: CGFloat = 0
//  @State var lastOffset: CGFloat = 0
//  @GestureState var gestureOffset: CGFloat = 0
//  
//  let minimumHeight: CGFloat = 44
//  var content: AnyView
//  
//  var body: some View {
//    GeometryReader { proxy in
//      let height = proxy.frame(in: .local).height
//      
//      ZStack(alignment: .bottom) {
//        VStack(spacing: 0) {
//          content
//            .padding(.horizontal, GridLayout.side)
//        }
//      } // ZStack
//      .frame(minHeight: minimumHeight, maxHeight: .infinity)
//      .offset(y: (height - minimumHeight * 2) / 2)
//      .offset(y: -offset > 0 ? -offset <= (height - minimumHeight) ? offset : -(height - minimumHeight) : 0)
//      .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
//        out = value.translation.height
//        onChange()
//      }).onEnded ({ value in
//        
//        let maxHeight = height - minimumHeight * 2
//        withAnimation {
//          // Logic conditions for moving states
//          if -offset > minimumHeight && -offset < maxHeight / 2 {
//            // mid
//            offset = -(maxHeight / 2)
//          }
//          else if -offset > maxHeight / 2 {
//            offset = -maxHeight
//          }
//          else {
//            offset = 0
//          }
//        }
//        
//        // Storing last offset
//        lastOffset = offset
//      }))
//    }
//  }
//  
//  func onChange() {
//    DispatchQueue.main.async {
//      self.offset = gestureOffset + lastOffset
//    }
//  }
//}

// MARK: - Previews
struct PlaceTagView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceTagView(placeId: .constant(""))
  }
}
