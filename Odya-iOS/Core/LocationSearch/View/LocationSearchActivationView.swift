//
//  LocationSearchActivationView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/14.
//

import SwiftUI

struct LocationSearchActivationView: View {
    // MARK: - Body
    var body: some View {
        HStack {
            Text("어디로 가시나요?")
                .foregroundColor(Color(.darkGray))
                .padding(.horizontal)
            Spacer()
            Image(systemName: "magnifyingglass")
                .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 46)
        .background(.white)
        .border(.black)
    }
}

// MARK: - Previews
struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
