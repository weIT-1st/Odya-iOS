//
//  TravelJournalDetailBottomSheet.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/26.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct OffsettableScrollView<T: View>: View {
  let axes: Axis.Set
  let showsIndicator: Bool
  let onOffsetChanged: (CGPoint) -> Void
  let content: T

  init(
    axes: Axis.Set = .vertical,
    showsIndicator: Bool = true,
    onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
    @ViewBuilder content: () -> T
  ) {
    self.axes = axes
    self.showsIndicator = showsIndicator
    self.onOffsetChanged = onOffsetChanged
    self.content = content()
  }

  var body: some View {
    ScrollView(axes, showsIndicators: showsIndicator) {
      GeometryReader { proxy in
        Color.clear.preference(
          key: OffsetPreferenceKey.self,
          value: proxy.frame(
            in: .named("ScrollViewOrigin")
          ).origin
        )
      }
      .frame(width: 0, height: 0)
      content
    }
    .coordinateSpace(name: "ScrollViewOrigin")
    .onPreferenceChange(
      OffsetPreferenceKey.self,
      perform: onOffsetChanged)
  }
}

struct JournalDetailBottomSheet: View {
  @EnvironmentObject var bottomSheetVM: BottomSheetViewModel

  let title: String
  let startDate: Date
  let endDate: Date
  var contents: [TravelJournalContent] = []

  @State private var isFeedType: Bool = true
  @State private var isAllExpanded: Bool = false
  @State private var showTravelMateList: Bool = false

  var startDateString: String {
    return startDate.dateToString(format: "yyyy.MM.dd")
  }
  var endDateString: String {
    return endDate.dateToString(format: "yyyy.MM.dd")
  }

  init(travelJournal: TravelJournalData) {
    title = travelJournal.title
    startDate = travelJournal.travelStartDate.toDate()!
    endDate = travelJournal.travelEndDate.toDate()!

    for i in 1...15 {
      self.contents.append(
        TravelJournalContent(
          travelJournalContentId: i,
          content:
            "형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라는 양반이 아들 형제를 두었는데 형의 이름 놀부요, 동생의 이름은 흥부였다. 틀림없는 한 어머니 소생이건만 흥부는 마음씨 착하고 효행이 지극하며 동기간의 우애가 극진한데, 놀부는 부모에게는 불효이고 동기간에 우애가 조금도 없으니, 그 마음 쓰는 것이 괴상하였다. 모든사람, 오장에 육부를 가졌지만 놀부는 당초부터 오장에 칠부였다. 말하자면 심술보가 하나 더 있어 심술보가 한번만 뒤집히면 심사를 야단스럽게도 피웠다.",
          latitudes: [],
          longitudes: [],
          travelDateString: "2023-06-01",
          images: []
        )
      )
    }

  }

  var body: some View {
    ZStack {
      OffsettableScrollView { point in
        if point.y != 0 {
          bottomSheetVM.isScrollAtTop = point.y > 0
        }
      } content: {
        journalInfo
          .padding(.horizontal, GridLayout.side)
          .padding(.top, 30)
          .padding(.bottom, 12)

        VStack(spacing: 24) {
          viewModeSelector

          ForEach(self.contents) { dailyJournal in
            let dayN: Int = Int(dailyJournal.travelDate.timeIntervalSince(self.startDate))
            DailyJournalView(
              dayN: dayN, dailyJournal: dailyJournal, isFeedType: $isFeedType,
              isAllExpanded: $isAllExpanded)
          }

        }
        .padding(.top, 25)
        .padding(.horizontal, GridLayout.side)
        .background(Color.odya.elevation.elev1)
        .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
      }.disabled(!bottomSheetVM.isSheetOn)

      // drag indicator
      VStack {
        Capsule()
          .fill(Color.odya.label.assistive)
          .frame(width: 80, height: 4)
          .padding(.vertical, 15)
        Spacer()
      }

    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    .background(Color.odya.background.dimmed_system)
    .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.medium))
    .ignoresSafeArea(edges: [.bottom])

  }

  private var journalInfo: some View {
    VStack(alignment: .leading) {
      // 여행 제목
      Text(title)
        .h5Style()
        .foregroundColor(.odya.label.normal)
        .lineLimit(bottomSheetVM.isSheetOn ? 1 : nil)
        .padding(.vertical)

      HStack {
        Button(action: {}) {
          // 함께 간 친구
          // TODO: 함께 간 친구 데이터에서 프로필 사진 가져오기
          // TODO: 친구 수에 따라 프로필 이미지 수, 더보기까지의 간격 조정하기
          HStack(spacing: 0) {
            Circle()
              .frame(width: 32, height: 32)
            Circle()
              .frame(width: 32, height: 32)
              .offset(x: -8)

            Text("더보기")
              .detail2Style()
              .foregroundColor(.odya.label.normal)
              .padding(.vertical, 10)
              .padding(.horizontal, 12)
          }
        }

        Spacer()

        // 여행 기간
        Text("\(startDateString) ~ \(endDateString)")
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
      }
    }
  }

  private var viewModeSelector: some View {
    HStack {
      Button(action: {
        isAllExpanded.toggle()
      }) {
        Text(!isAllExpanded ? "전부 펼쳐보기" : "전부 접기")
          .b1Style()
          .foregroundColor(.odya.label.alternative)
      }
      Spacer()
      IconButton("feed") {
        isFeedType = true
      }
      .colorMultiply(isFeedType ? Color.odya.brand.primary : Color.odya.label.normal)
      IconButton("grid") {
        isFeedType = false
      }
      .colorMultiply(!isFeedType ? Color.odya.brand.primary : Color.odya.label.normal)

    }
  }
}

struct JournalDetailBottomSheet_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalDetailView()
    //        JournalDetailBottomSheet(isSheetOn: .constant(.journalDetailOn), travelJournal: TravelJournalData.getDummy())
  }
}
