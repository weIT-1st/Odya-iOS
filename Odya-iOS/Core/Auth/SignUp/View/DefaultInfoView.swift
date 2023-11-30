//
//  RegisterDefaultInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/30.
//

import SwiftUI

/// 사용자 성별 및 생일 정보 입력 뷰
/// 입력 받은 후 다음 버튼을 클릭 시 서버에 등록(회원가입)이 진행됨
struct RegisterDefaultInfoView: View {
  // MARK: Properties
  
  @EnvironmentObject var signUpVM: SignUpViewModel // signUp() 사용하기 위함..
  
  /// 생일 및 성별 유효성 검사
  @StateObject var validatorApi = AuthValidatorApiViewModel()
  
  /// 회원가입 단계
  @Binding var signUpStep: Int
  
  /// 회원가입할 사용자 정보
  @Binding var userInfo: SignUpInfo
  
  /// 이전 단계에서 입력받은 닉네임
  var nickname: String { userInfo.nickname }
  
  /// 입력받은 생일
  @State private var birthday = Date()
  
  /// 입력받은 성별
  @State private var gender = Gender.none

  /// 생일 정보 편집 여부
  private var isEditingBirthday: Bool {
    let birthdayString = birthday.dateToString(format: "yyyy년 MM월 dd일")
    let todayString = Date().dateToString(format: "yyyy년 MM월 dd일")
    return birthdayString != todayString
  }
  
  /// 성별 정보 편집 여부
  private var isEditingGender: Bool {
    gender != .none
  }
  
  /// 다음 단계로 넘어갈 수 있는지 여부
  /// 성별 및 생일 편집 여부만 확인
  private var isNextButtonActive: ButtonActiveSate {
    return isEditingBirthday && isEditingGender ? .active : .inactive
  }
  
  /// 생일 피커 바텀시트 화면 표시 여부
  @State private var isShowingDatePickerSheet: Bool = false
  
  init(_ step: Binding<Int>, userInfo: Binding<SignUpInfo>) {
    self._signUpStep = step
    self._userInfo = userInfo
  }
  
  // MARK: Body
  var body: some View {
    VStack {
      Spacer()
      
      VStack(alignment: .leading, spacing: 0) {
        titleText
          .frame(height: 160) // 뒷페이지와 title height 맞추기용
        birtydayField
          .padding(.bottom, 15)
        genderField
      }
      .padding(.horizontal, GridLayout.side)
        
      Spacer()
      
      // next button
      CTAButton( isActive: isNextButtonActive, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        userInfo.birthday = birthday
        userInfo.gender = gender
        // 서버에 회원 등록 진행, 성공 시 회원가입 단계 1 증가
        signUpVM.signUp()
      }
      .padding(.bottom, 45)
    }
    .onAppear {
      self.birthday = userInfo.birthday
      self.gender = userInfo.gender
    }
  }  // body
  
  // MARK: Title
  
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
      
      Spacer()
    }
  }
  
  // MARK: Birthday
  /// 생일 입력 버튼, 클릭시 날짜 피커 시트가 올라옴
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
      self.generateBirthdatePickerView()
        .presentationDetents([.fraction(0.33)])
    }
  }
  
  // MARK: Gender
  /// 성별 선택 버튼
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

// MARK: Birth Date Picker Sheet

extension RegisterDefaultInfoView {
  func generateBirthdatePickerView() -> some View {
    // TODO: 가입 가능한 연령대 확인
    return DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
      Text("Birthdate")
    }
    .datePickerStyle(.wheel)
    .labelsHidden()
    .onTapGesture {
      isShowingDatePickerSheet.toggle()
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
