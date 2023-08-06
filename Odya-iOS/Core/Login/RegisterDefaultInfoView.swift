//
//  RegisterDefaultInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/30.
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
        .pickerStyle(InlinePickerStyle())
        .onTapGesture {
            isGenderPickerVisible.toggle()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, GridLayout.side)
        .padding(.vertical, 18)
        .background(Color.odya.elevation.elev3)
    }
}

struct RegisterDefaultInfoView: View {
    @Binding var step: Int
    
    // user info
    let nickname: String
    @Binding var birthday: Date
    @Binding var gender: Gender
    
    @State private var isDatePickerVisible = false
    @State private var isGenderPickerVisible = false
    
    var birthdayText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: birthday)
        return dateString == dateFormatter.string(from: Date()) ? "생년월일" : dateString
    }
    
    var genderText: String {
        return gender.toKorean()
    }
    
    var body: some View {

        ZStack {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text("\(nickname)")
                        .h3Style()
                        .foregroundColor(.odya.brand.primary)
                    Text("님이")
                        .h3Style()
                        .foregroundColor(.odya.label.normal)
                }
                Text("궁금해요!")
                    .h3Style()
                    .foregroundColor(.odya.label.normal)
                
                
                Button(action: {
                    isGenderPickerVisible = false
                    isDatePickerVisible.toggle()
                }, label: {
                    HStack(spacing: 0) {
                        Text("\(birthdayText)")
                            .foregroundColor(.odya.label.inactive)
                            .b1Style()
                        Spacer()
                        Image("direction-down")
                            .padding(.horizontal, 6)
                    }
                    .modifier(CustomFieldStyle())
                })
                
                Button(action: {
                    isDatePickerVisible = false
                    isGenderPickerVisible.toggle()
                }, label: {
                    HStack(spacing: 0) {
                        Text(genderText)
                            .b1Style()
                            .foregroundColor(.odya.label.inactive)
                        
                        Spacer()
                        Image("direction-down")
                            .padding(.horizontal, 6)
                    }
                    .modifier(CustomFieldStyle())
                })
            }.padding(.horizontal, GridLayout.side)
            
            VStack {
                Spacer()
                CTAButton(isActive: .active, buttonStyle: .solid,
                          labelText: "회원가입", labelSize: .L, action: {
                    print("회원가입 버튼 클릭")
                    // TODO: check birthday and gender is valid
                    if isValidInfo(birthday, birthdayText, gender) {
                        self.step += 1
                    } else {
                        print("invalid info")
                    }
                }).padding(.bottom, 45)
            }
            
            // picker Views
            if isDatePickerVisible {
                VStack {
                    Spacer()
                    BirthdatePickerView(isDatePickerVisible: $isDatePickerVisible, birthday: $birthday)
                }
            }

            if isGenderPickerVisible {
                VStack {
                    Spacer()
                    GenderPickerView(isGenderPickerVisible: $isGenderPickerVisible, selectedGender: $gender)
                }
            }
        }
        
        
    } // body
    
    private func isValidInfo(_ birthday: Date, _ birthdayText: String,
                             _ gender: Gender) -> Bool {
        if birthdayText == "생년월일" { return false }
        if gender == .none { return false }
        return true
    }
}

struct RegisterDefaultInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterDefaultInfoView(step: .constant(2),
                                nickname: "길동아밥먹자",
                                birthday: .constant(Date()),
                                gender: .constant(Gender.none))
    }
}

