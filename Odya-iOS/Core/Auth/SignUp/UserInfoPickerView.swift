//
//  UserInfoPickers.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/07.
//

import SwiftUI

struct BirthdatePickerView: View {
  @Binding var isDatePickerVisible: Bool
  @Binding var birthday: Date

  var body: some View {
    // TODO: 가입 가능한 연령대 확인
    DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
      Text("Birthdate")
    }
    .datePickerStyle(.wheel)
    .labelsHidden()
    .onTapGesture {
      isDatePickerVisible.toggle()
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, GridLayout.side)
    .padding(.vertical, 18)
    .background(Color.odya.elevation.elev3)

  }
}

struct GenderPickerView: View {
  @Binding var isGenderPickerVisible: Bool
  @Binding var selectedGender: Gender

  var body: some View {
    Picker("Gender", selection: $selectedGender) {
      Text("성별").tag(Gender.none)
      Text("남성").tag(Gender.male)
      Text("여성").tag(Gender.female)
    }
    .pickerStyle(WheelPickerStyle())
    .onTapGesture {
      isGenderPickerVisible.toggle()
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, GridLayout.side)
    .padding(.vertical, 18)
    .background(Color.odya.elevation.elev3)
  }
}
