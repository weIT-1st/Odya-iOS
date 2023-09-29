//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

struct SplarkleIcon: View {
    var body: some View {
        Image("sparkle-filled")
            .shadow(color: .odya.brand.primary.opacity(0.8), radius:9, x: 0, y: 0)
    }
}

struct DailyJournalView: View {
    let dayN: Int
    let dateString: String
    let content: String
    let placeName: String
    let placeLoc: String
    var images: [UIImage] = []
    
    var displayedImages: [UIImage] {
        if isExpanded {
            return images
        } else {
            return isFeedType ? Array(images.prefix(2)) : Array(images.prefix(9))
        }
    }
    
    @Binding var isFeedType: Bool
    @Binding var isAllExpanded: Bool
    @State var isExpanded: Bool = false
    let imageListWidth: CGFloat = UIScreen.main.bounds.width - GridLayout.side * 2 - 50 // 50 = DayN VStack width
    
    
    init(dayN: Int, dailyJournal: TravelJournalContent, isFeedType: Binding<Bool>, isAllExpanded: Binding<Bool>) {
        self.dayN = dayN
        self.dateString = dailyJournal.travelDate.dateToString(format: "yyyy.MM.dd")
        self.content = dailyJournal.content
        self.placeName = "덕수궁 돌담길"
        self.placeLoc = "서울특별시 중구"
        self._isFeedType = isFeedType
        self._isAllExpanded = isAllExpanded
        
        for i in 1...10 {
            let image = UIImage(named: "photo_example \(i)")
            if let image = image {
                self.images.append(image)
                
            } else {
                print("error")
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // DayN VStack
            VStack(spacing: 12) {
                Text("Day\(dayN)")
                    .b1Style()
                    .foregroundColor(.odya.label.normal)
                    .frame(height: 12)
                    .padding(.bottom, 7)
                SplarkleIcon()
                Rectangle()
                    .frame(width: 4)
                    .foregroundColor(Color.odya.elevation.elev6)
            }.frame(width: 50)
            
            // Content VStack
            VStack(spacing: 16) {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    HStack {
                        Text(dateString)
                            .b1Style()
                            .foregroundColor(.odya.label.assistive)
                        Spacer()
                        Image(isExpanded ? "direction-up" : "direction-down")
                    }.frame(height: 36)
                }
                
                Divider().frame(height: 1).background(Color.odya.line.alternative)
                
                // content
                Text(content)
                    .detail2Style()
                    .foregroundColor(.odya.label.normal)
                    .lineLimit(isExpanded ? nil : 2)
                
                // image list
                if isFeedType {
                    imageFeedView
                } else {
                    ImageGridView(images: displayedImages, totalWidth: imageListWidth, spacing: 3)
                }
                
                placeInfo
            }
            .padding(.bottom, 40)
            .animation(.easeInOut, value: isExpanded)
            .onChange(of: isAllExpanded) { newValue in
                isExpanded = newValue
            }
            
        }

    }
    
    private var imageFeedView: some View {
        VStack(spacing: 15) {
            ForEach(displayedImages, id: \.self) { anImage in
                Image(uiImage: anImage)
                    .resizable()
                    .frame(width: imageListWidth)
                    .scaledToFit()
                    .cornerRadius(Radius.small)
            }
        }
    }
    
    private var placeInfo: some View {
        HStack {
            HStack(spacing: 7) {
                Image("location-m")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                Text(placeName)
                    .detail2Style()
            }.foregroundColor(.odya.brand.primary)
            Spacer()
            Text(placeLoc)
                .detail2Style()
                .foregroundColor(.odya.label.assistive)
        }
    }
    
    
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        DailyJournalView(dayN: 1, dailyJournal: TravelJournalContent(
            travelJournalContentId: 1,
            content: "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.",
            latitudes: [],
            longitudes: [],
            travelDateString: "2023-06-01",
            images: []
        ), isFeedType: .constant(true), isAllExpanded: .constant(false))
    }
}
