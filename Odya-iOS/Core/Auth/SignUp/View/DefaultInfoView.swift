//
//  RegisterDefaultInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/30.
//

import SwiftUI

struct RegisterDefaultInfoView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel // signUp() 사용하기 위함..
  @StateObject var validatorApi = AuthValidatorApiViewModel()
  
  @Binding var signUpStep: Int
  
  @Binding var userInfo: SignUpInfo
  
  var nickname: String { userInfo.nickname }
  @State private var birthday = Date()
  @State private var gender = Gender.none

  private var isEditingBirthday: Bool {
    let birthdayString = birthday.dateToString(format: "yyyy년 MM월 dd일")
    let todayString = Date().dateToString(format: "yyyy년 MM월 dd일")
    return birthdayString != todayString
  }
  
  private var isEditingGender: Bool {
    gender != .none
  }
  
  private var isNextButtonActive: ButtonActiveSate {
    return isEditingBirthday && isEditingGender ? .active : .inactive
  }
  
  @State private var isShowingDatePickerSheet: Bool = false
  
  init(_ step: Binding<Int>, userInfo: Binding<SignUpInfo>) {
    self._signUpStep = step
    self._userInfo = userInfo
  }
  
  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 15) {
        titleText
          .frame(height: 130) // 뒷페이지와 높이 맞추기용
          .padding(.top, 120) // 뒷페이지와 높이 맞추기용
          .padding(.bottom, 30) // 뒷페이지와 높이 맞추기용
        birtydayField
        genderField
      }.padding(.horizontal, GridLayout.side)
        
      Spacer()
      
      // next button
      CTAButton( isActive: isNextButtonActive, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        userInfo.birthday = birthday
        userInfo.gender = gender
        // TODO: 회원가입
        signUpVM.signUp()
        
//        signUpStep += 1
      }
      .padding(.bottom, 45)
    }
    .onAppear {
      self.birthday = userInfo.birthday
      self.gender = userInfo.gender
    }
  }  // body
  
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 10) {
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          Text(nickname)
            .foregroundColor(.odya.brand.primary)
          Text("님이")
            .foregroundColor(.odya.label.normal)
        }
        Text("궁금해요!")
          .foregroundColor(.odya.label.normal)
      }.h3Style()
      
      Text("성별과 생년월일은 수정할 수 없어요. \n정확한 정보를 입력해주세요!")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }
  
  private var birtydayField: some View {
    Button(action: {
        isShowingDatePickerSheet.toggle()
    }) {
        HStack(spacing: 0) {
          Text(isEditingBirthday ? birthday.dateToString(format: "yyyy년 MM월 dd일") : "생년월일")
            .foregroundColor(isEditingBirthday ? .odya.label.normal : .odya.label.inactive)
            .b1Style()
          Spacer()
          Image("direction-down")
            .padding(.horizontal, 6)
        }
        .modifier(CustomFieldStyle())
    }
    .sheet(isPresented: $isShowingDatePickerSheet) {
      BirthdatePickerView(isDatePickerVisible: $isShowingDatePickerSheet, birthday: $birthday)
        .presentationDetents([.fraction(0.33)])
    }
  }
  
  private var genderField: some View {
    Menu {
      Button("성별") { gender = .none }
      Button("남성") { gender = .male }
      Button("여성") { gender = .female }
    } label: {
      HStack(spacing: 0) {
        Text(gender.toKorean())
          .b1Style()
          .foregroundColor(isEditingGender ? .odya.label.normal : .odya.label.inactive)
        
        Spacer()
        Image("direction-down")
          .padding(.horizontal, 6)
      }
      .modifier(CustomFieldStyle())
    }
  }
}

private struct BirthdatePickerView: View {
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

//struct RegisterDefaultInfoView_Previews: PreviewProvider {
//  static var previews: some View {
//    SignUpView()
//  }
//}
