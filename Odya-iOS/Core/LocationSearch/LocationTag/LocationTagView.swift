//
//  LocationTagView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI

/// 장소 태그하기 뷰
struct LocationTagView: View {
    // MARK: Properties
    @State var showBottomSheet = true
    
    // MARK: Body
    
    var body: some View {
        VStack {
            navigationBar
            
            // map
            MapView()
            
            // bottom sheet
            CustomBottomSheet(isShowing: $showBottomSheet, content: AnyView(LocationTagSearchView()))
        }
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
                        .foregroundColor(Color.odya.label.assistive)
                        .padding(.horizontal, 4)
                }

            }
            .padding(.trailing, 12)
        }
    }
}

struct CustomBottomSheet: View {
    @Binding var isShowing: Bool
    var content: AnyView
    
    var body: some View {
        if isShowing {
            VStack {
                Image("home-indicator")
                    .resizable()
                    .frame(height: 21)
                    .frame(maxWidth: .infinity)
                content
                    .padding(.horizontal, GridLayout.side)
                    .transition(.move(edge: .bottom))
                    .clipShape(RoundedEdgeShape(edgeType: .top))
                    
            }
            .frame(maxWidth: .infinity)
            .background(Color.odya.background.normal)
            .animation(.easeOut, value: isShowing)
        }
    }
}

// MARK: - Previews
struct LocationTagView_Previews: PreviewProvider {
    static var previews: some View {
        LocationTagView()
    }
}
