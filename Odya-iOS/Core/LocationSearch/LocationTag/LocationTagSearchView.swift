//
//  LocationTagSearchView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/18.
//

import SwiftUI

struct LocationTagSearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // search bar
            HStack {
                TextField("장소를 찾아보세요!", text: $searchText)
                    .b1Style()
                    .foregroundColor(Color.odya.label.inactive)
                    .padding(.leading, 20)
                Spacer()
                IconButton("search") {
                    // action: 검색
                }
                .foregroundColor(Color.odya.label.inactive)
                .frame(width: 48, height: 48, alignment: .center)
            }
            .padding(.vertical, 8)
            .background(Color.odya.elevation.elev5)
            .cornerRadius(Radius.medium)
            .padding(.vertical, 12)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<5) { _ in
                        LocationTagResultCell()
                        Divider()
                    }
                }
            }
        }
        .toolbar(.hidden)
    }
}

struct LocationTagResultCell: View {
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                Text("타이틀")
                    .b1Style()
                    .foregroundColor(Color.odya.label.normal)
                Text("상세주소")
                    .detail2Style()
                    .foregroundColor(Color.odya.label.alternative)
            }
            
            Spacer()
            
            IconButton("system-check-circle") {
                // action: check
            }
            .foregroundColor(Color.odya.system.inactive)
            .padding(10)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
}

struct LocationTagSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationTagSearchView()
    }
}
