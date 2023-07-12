//
//  TestView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/30.
//

import SwiftUI

struct TestView: View {
    // MARK: - Properties
    
    @StateObject var viewModel = TestViewModel()
    @State var name = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 25) {
            TextField("이름을 입력하세요.", text: $name)
                .submitLabel(.done)
                .frame(height: 48)
                .onSubmit {
                    viewModel.submitUsername(username: name)
                }
            
            Button {
                viewModel.submitUsername(username: name)
            } label: {
                Text("제출")
                    .foregroundColor(.black)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .background(.white)

        }
        .padding(.horizontal)
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
