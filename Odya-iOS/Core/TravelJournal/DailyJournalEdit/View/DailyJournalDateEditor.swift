//
//  JournalDateEditor.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/12.
//

import SwiftUI

// MARK: Daily journal date editor

/// 데일리 일정 날짜 피커 뷰
/// 데일리 일정 수정 시에 사용됨
struct DailyJournalDateEditor: View {

  // MARK: Properties
  @Binding var isDatePickerVisible: Bool
  @Binding var selectedDate: Date
  @State private var newDate: Date

  let startDate: Date
  let endDate: Date

  init(
    editedDate: Binding<Date>, travelStartDate: Date, travelEndDate: Date,
    isDatePickerVisible: Binding<Bool>
  ) {
    self._isDatePickerVisible = isDatePickerVisible
    self._selectedDate = editedDate
    self._newDate = State(initialValue: editedDate.wrappedValue)

    self.startDate = travelStartDate
    self.endDate = travelEndDate
  }

  // MARK: Body

  var body: some View {
    VStack(spacing: 15) {
      DatePicker(
        "Travel Daily Journal Date",
        selection: $newDate,
        in: startDate...endDate,
        displayedComponents: [.date]
      )
      .datePickerStyle(.graphical)
      .labelsHidden()
      .accentColor(.odya.brand.primary)
      .detail2Style()

      HStack {
        Button(action: {
          isDatePickerVisible = false
        }) {
          Text("취소")
            .b1Style()
            .foregroundColor(.odya.label.alternative)
            .frame(maxWidth: .infinity)
            .padding(10)
        }

        Button(action: {
          selectedDate = newDate
          isDatePickerVisible = false
        }) {
          Text("확인")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
            .frame(maxWidth: .infinity)
            .padding(10)
        }

      }
    }
    .padding(15)
    .background(Color.odya.elevation.elev2)
    .cornerRadius(Radius.small)
  }
}
