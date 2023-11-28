//
//  TopicTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/27.
//

import SwiftUI

struct TopicTestView: View {
    let tags: [String] = ["#사다리타기", "#돌림판", "#포춘쿠키", "#번역기", "#제비뽑기", "#날씨", "#D-Day", "#환율", "#오늘의날씨는좋다"]

    var body: some View {
        ScrollView {
            FlowLayoutView(tags: tags)
                .padding()
        }
    }
}

struct FlowLayoutView: View {
    let tags: [String]

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.body)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
}

struct TopicTestView_Previews: PreviewProvider {
    static var previews: some View {
      TopicTestView()
    }
}


//import SwiftUI
//
//struct TopicTestView: View {
//    let buttonTexts = ["사다리타기", "돌림판", "포춘쿠키", "번역기", "제비뽑기", "날씨", "D-Day", "환율", "오늘의날씨는좋다"]
//
//    var body: some View {
//        VStack {
//            ForEach(buttonTexts.chunked(into: 3), id: \.self) { rowTexts in
//                HStack(spacing: 10) {
//                    Spacer() // 왼쪽 여백
//                    ForEach(rowTexts, id: \.self) { buttonText in
//                        GeometryReader { geometry in
//                            Button(action: {
//                                // 버튼이 클릭되었을 때의 동작 추가
//                                print("\(buttonText) 버튼이 클릭되었습니다.")
//                            }) {
//                                Text(buttonText)
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                                    .frame(width: geometry.size.width) // 버튼 크기를 동일하게 설정
//                            }
//                        }
//                        .frame(height: 40) // 높이를 고정
//                        Spacer() // 버튼 간 여백
//                    }
//                    Spacer() // 오른쪽 여백
//                }
//                .alignmentGuide(.leading, computeValue: { d in d[HorizontalAlignment.center] })
//            }
//        }
//        .padding()
//    }
//}
//
//// 배열을 원하는 크기로 나누는 extension
////extension Array {
////    func chunked(into size: Int) -> [[Element]] {
////        return stride(from: 0, to: count, by: size).map {
////            Array(self[$0..<Swift.min($0 + size, count)])
////        }
////    }
////}
//
//struct TopicTestView_Previews: PreviewProvider {
//    static var previews: some View {
//      TopicTestView()
//    }
//}
