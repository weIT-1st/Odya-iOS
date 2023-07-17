//
//  TestView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/30.
//

//import SwiftUI
//
//struct TestView: View {
//    let shared = TestApiService()
//
//    @State var name = ""
//
//    var body: some View {
//        VStack(spacing: 25) {
//            TextField("이름을 입력하세요.", text: $name)
//                .submitLabel(.done)
//                .frame(height: 48)
//                .background(Color(.systemGroupedBackground))
//                .onSubmit {
//                    shared.postUsername(name: name)
//                }
//
//            Button {
//                shared.postUsername(name: name)
//            } label: {
//                Text("제출")
//                    .foregroundColor(.white)
//                    .frame(height: 48)
//                    .frame(maxWidth: .infinity)
//            }
//            .background(.black)
//
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct NetworkView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
