//
//  HomeView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/23.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    
    @State private var showLocationSearchView = false

    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView()
            
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            } else {
                LocationSearchActivationView()
                    .onTapGesture {
                        showLocationSearchView = true
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
