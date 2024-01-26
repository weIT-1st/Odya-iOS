//
//  TravelInfoEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import SwiftUI

// MARK: Travel date view

struct TravelDateEditView: View {
  var date: Date

  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Text(date.dateToString(format: "yyyy년 M월 d일"))
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Text(date.dateToString(format: "EEEE"))
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }

}

// MARK: Travel date picker

/// 여행 일자 피커뷰, 시작일 마지막일을 선택
struct TravelDatePickerView: View {

  // MARK: Properties

  @ObservedObject var journalComposeVM: JournalComposeViewModel
  @Binding var isDatePickerVisible: Bool

  @State private var selectedStartDate: Date = Date()
  @State private var selectedEndDate: Date = Date()
  @State private var isStartDatePicked: Bool = true

  var endDateLimit: Date {
    if let endDate = selectedStartDate.addDays(14) {
      let today = Date()
      return endDate > today ? today : endDate
    } else {
      return selectedStartDate
    }
  }

  var isDatesValid: Bool {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: selectedStartDate, to: selectedEndDate)
    guard let day = components.day else {
      return false
    }
    let duration = day + 1
    return duration > 0 && duration <= 15
  }

  // MARK: body

  var body: some View {
    VStack(spacing: 15) {
      HStack(spacing: 8) {
        Button(action: { isStartDatePicked = true }) {
          startDateView
        }
        Button(action: { isStartDatePicked = false }) {
          endDateView
        }
      }

      if isStartDatePicked {
        startDatePicker
      } else {
        endDatePicker
      }

      HStack {
        Button(action: { isDatePickerVisible = false }) {
          Text("취소")
            .b1Style()
            .foregroundColor(.odya.label.alternative)
            .frame(maxWidth: .infinity)
            .padding(10)
        }

        Button(action: {
          journalComposeVM.setTravelDates(startDate: selectedStartDate, endDate: selectedEndDate)
          isDatePickerVisible = false
        }) {
          Text("확인")
            .b1Style()
            .foregroundColor(isDatesValid ? .odya.brand.primary : .odya.label.alternative)
            .frame(maxWidth: .infinity)
            .padding(10)
        }.disabled(!isDatesValid)
      }
    }
    .padding(15)
    .background(Color.odya.elevation.elev2)
    .cornerRadius(Radius.small)
    .onAppear {
      selectedStartDate = journalComposeVM.startDate
      selectedEndDate = journalComposeVM.endDate
    }
  }

  // MARK: selected date views

  private var startDateView: some View {
    VStack(spacing: 0) {
      Text(selectedStartDate.dateToString(format: "yyyy년"))
        .detail1Style()
      Text(selectedStartDate.dateToString(format: "M월 d일 (E)"))
        .b1Style()
    }
    .frame(maxWidth: .infinity)
    .padding(10)
    .foregroundColor(isStartDatePicked ? .odya.background.normal : .odya.label.alternative)
    .background(isStartDatePicked ? Color.odya.brand.primary : .clear)
    .cornerRadius(Radius.small)
  }

  private var endDateView: some View {
    VStack(spacing: 0) {
      Text(selectedEndDate.dateToString(format: "yyyy년"))
        .detail1Style()
      Text(selectedEndDate.dateToString(format: "M월 d일 (E)"))
        .b1Style()
    }
    .frame(maxWidth: .infinity)
    .padding(10)
    .foregroundColor(!isStartDatePicked ? .odya.background.normal : .odya.label.alternative)
    .background(!isStartDatePicked ? Color.odya.brand.primary : .clear)
    .cornerRadius(Radius.small)
  }

  // MARK: date picker views

  private var startDatePicker: some View {
    DatePicker(
      "Travel StartDate",
      selection: isStartDatePicked ? $selectedStartDate : $selectedEndDate,
      in: ...selectedEndDate,
      displayedComponents: [.date]
    )
    .datePickerStyle(.graphical)
    .labelsHidden()
    .accentColor(.odya.brand.primary)
    .detail2Style()
    .frame(height: 350, alignment: .top)
  }

  private var endDatePicker: some View {
    DatePicker(
      "Travel EndDate",
      selection: $selectedEndDate,
      in: selectedStartDate...endDateLimit,
      displayedComponents: [.date]
    )
    .datePickerStyle(.graphical)
    .labelsHidden()
    .accentColor(.odya.brand.primary)
    .detail2Style()
    .frame(height: 350, alignment: .top)
    .onAppear {
      if let newEndDate = selectedStartDate.addDays(1),
        newEndDate <= endDateLimit
      {
        selectedEndDate = newEndDate
      } else {
        selectedEndDate = selectedStartDate
      }
    }
  }
}

// MARK: Daily journal date picker

/// 데일리 일정 날짜 피커 뷰
struct DailyJournalDatePicker: View {

  // MARK: Properties

  @EnvironmentObject var journalComposeVM: JournalComposeViewModel

  @State private var selectedDate: Date = Date()

  var startDate: Date { journalComposeVM.startDate }
  var endDate: Date { journalComposeVM.endDate }

  @Environment(\.dismiss) private var dismiss

  // MARK: Body

  var body: some View {
    VStack(spacing: 15) {
      DatePicker(
        "Travel Daily Journal Date",
        selection: $selectedDate,
        in: startDate...endDate,
        displayedComponents: [.date]
      )
      .datePickerStyle(.graphical)
      .labelsHidden()
      .accentColor(.odya.brand.primary)
      .detail2Style()

      HStack {
        Button(action: {
          journalComposeVM.pickedJournalIndex = nil
          dismiss()
        }) {
          Text("취소")
            .b1Style()
            .foregroundColor(.odya.label.alternative)
            .frame(maxWidth: .infinity)
            .padding(10)
        }

        Button(action: {
          journalComposeVM.setJournalDate(newDate: selectedDate)
          journalComposeVM.pickedJournalIndex = nil
          dismiss()
          journalComposeVM.dailyJournalList.sort()
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
    .onAppear {
      if let pickedIdx = journalComposeVM.pickedJournalIndex,
        let orgDate = journalComposeVM.dailyJournalList[pickedIdx].date
      {
        self.selectedDate = orgDate
      } else {
        self.selectedDate = journalComposeVM.startDate
      }
    }
  }
}
