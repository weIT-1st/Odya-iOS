//
//  PlaceTagView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI

/// 장소 태그하기 뷰
struct PlaceTagView: View {
  // MARK: Properties
  @State private var showBottomSheet: Bool = false
  @Binding var placeId: String    // 장소ID
  
  // MARK: Body
  
  var body: some View {
    VStack(spacing: 0) {
      // custom navigation bar
      navigationBar
      
      ZStack {
        // map
        MapView()
        
        // bottom sheet
        CustomBottomSheet(content: AnyView(PlaceTagSearchView(placeId: $placeId)))
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
            .foregroundColor(self.placeId.isEmpty ? Color.odya.label.assistive : Color.odya.label.normal)
            .padding(.horizontal, 4)
        }
        .disabled(self.placeId.isEmpty)
      }
      .padding(.trailing, 12)
    }
  }
}

struct CustomBottomSheet: View {
  /// Gesture
  @State var offset: CGFloat = 0
  @State var lastOffset: CGFloat = 0
  @GestureState var gestureOffset: CGFloat = 0
  
  let mininumHeight: CGFloat = 44
  var content: AnyView
  
  var body: some View {
    GeometryReader { proxy in
      let height = proxy.frame(in: .local).height
      
      ZStack {
        Color.odya.background.normal
          .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: 24))
        
        VStack(spacing: 0) {
          VStack {
            Capsule()
              .fill(Color.odya.label.normal)
              .frame(width: 134, height: 5)
              .padding(.top, 21)
              .padding(.bottom, 8)
          }
          
          content
            .padding(.horizontal, GridLayout.side)
        }
      } // ZStack
      .offset(y: height - mininumHeight)
      .offset(y: -offset > 0 ? -offset <= (height - mininumHeight) ? offset : -(height - mininumHeight) : 0)
      .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
        out = value.translation.height
        onChange()
      }).onEnded ({ value in
        
        let maxHeight = height - mininumHeight * 2
        withAnimation {
          // Logic conditions for moving states
          if -offset > mininumHeight && -offset < maxHeight / 2 {
            // mid
            offset = -(maxHeight / 2)
          }
          else if -offset > maxHeight / 2 {
            offset = -maxHeight
          }
          else {
            offset = 0
          }
        }
        
        // Storing last offset
        lastOffset = offset
      }))
    }
  }
  
  func onChange() {
    DispatchQueue.main.async {
      self.offset = gestureOffset + lastOffset
    }
  }
}

// MARK: - Previews
struct PlaceTagView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceTagView(placeId: .constant(""))
  }
}
