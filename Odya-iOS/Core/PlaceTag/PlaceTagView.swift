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
        CustomBottomSheet(isShowing: $showBottomSheet, maxHeight: UIScreen.main.bounds.height * 0.7, content: AnyView(PlaceTagSearchView()))
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
  @GestureState private var translation: CGFloat = 0
  @Binding var isShowing: Bool
  
  let maxHeight: CGFloat
  let minHeight: CGFloat
  var content: AnyView
  let snapRatio: CGFloat = 0.25
  
  private var offset: CGFloat {
    return isShowing ? 0 : maxHeight - minHeight
  }
  
  init(isShowing: Binding<Bool>, maxHeight: CGFloat, content: AnyView) {
    self._isShowing = isShowing
    self.maxHeight = maxHeight
    self.minHeight = maxHeight * 0.3
    self.content = content
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Image("home-indicator")
          .frame(maxWidth: .infinity)
        //                    .onTapGesture {
        //                        self.isShowing.toggle()
        //                    }
        content
          .padding(.horizontal, GridLayout.side)
          .transition(.move(edge: .bottom))
          .clipShape(RoundedEdgeShape(edgeType: .top))
          .frame(alignment: .bottom)
        
      }
      .frame(width: geometry.size.width, height: self.maxHeight, alignment: .bottom)
      .background(Color.odya.background.normal)
      .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: 24))
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: max(self.offset + self.translation, 0))
      .animation(.interactiveSpring(), value: isShowing)
      .gesture(
        DragGesture().updating(self.$translation) { value, state, _ in
          state = value.translation.height
        }.onEnded { value in
          let snapDistance = self.maxHeight * self.snapRatio
          guard abs(value.translation.height) > snapDistance else {
            return
          }
          self.isShowing = value.translation.height < 0
        }
      )
      .padding(.top, 40)
    }
  }
}

// MARK: - Previews
struct PlaceTagView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceTagView(placeId: .constant(""))
  }
}

