//
//  TravelJournalEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/17.
//

import SwiftUI

// MARK: Travel Info Edit Section
private struct TravelJournalInfoEditView: View {
  @EnvironmentObject var travelJournalEditVM: TravelJournalEditViewModel

  private let titleCharacterLimit = 20
  @Binding var isDatePickerVisible: Bool
  @AppStorage("WeITAuthToken") var idToken: String?
  var userId = MyData().userID

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("여행 정보")
        .foregroundColor(.odya.label.normal)
        .h4Style()

      titleTextField
      travelDateEditField
      Divider().frame(height: 1).background(Color.odya.line.alternative)
      travelMatesEditField
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 28)
    .background(Color.odya.background.normal)
  }

  /// 여행일지 이름
  private var titleTextField: some View {
    TextField(
      "", text: $travelJournalEditVM.title,
      prompt: Text("여행일지 이름")
        .foregroundColor(.odya.label.assistive)
    )
    .foregroundColor(.odya.label.normal)
    .h6Style()
    .modifier(
      CustomFieldStyle(height: 45, backgroundColor: .odya.elevation.elev2, radius: Radius.small)
    )
    .onChange(of: travelJournalEditVM.title) { newValue in
      if newValue.count > titleCharacterLimit {
        travelJournalEditVM.title = String(newValue.prefix(titleCharacterLimit))
      }
    }
  }

  // 여행 시작/마지막 날짜 선택
  private var travelDateEditField: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 12) {
        Image("date-start")
        Image("date-end")
      }
      .colorMultiply(.odya.brand.primary)

      Button(action: { isDatePickerVisible = true }) {
        VStack(alignment: .leading, spacing: 12) {
          TravelDateEditView(date: travelJournalEditVM.startDate)
          TravelDateEditView(date: travelJournalEditVM.endDate)
        }.padding(.horizontal, 12)
      }
    }.padding(.horizontal, 12)
  }

  // 함께 간 친구
  private var travelMatesEditField: some View {
    HStack(spacing: 8) {
      Image("person-off")
      Text("함께 간 친구")
        .b2Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      travelMatesView
      NavigationLink(destination: {
        TravelMateSelectorView(
          token: idToken ?? "", userId: userId
        )
        .environmentObject(travelJournalEditVM)
        .navigationBarHidden(true)
      }) {
        Image("plus").padding(6)
      }
    }
  }

  // 선택된 함깨 간 친구
  private var travelMatesView: some View {
    HStack(spacing: 0) {
      ForEach(Array(travelJournalEditVM.travelMates.prefix(3).enumerated()), id: \.element.id) {
        (index, mate) in
        ProfileImageView(of: mate.nickname, profileData: mate.profile, size: .XS)
          .offset(x: CGFloat(index * -4))
      }

      if travelJournalEditVM.travelMates.count > 3 {
        Text("외 \(travelJournalEditVM.travelMates.count - 3)명")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .frame(width: 33)
          .lineLimit(1)
      }
    }
  }
}

struct TravelJournalComposeView: View {
  // MARK: Properties

  @StateObject var travelJournalEditVM = TravelJournalEditViewModel()

  @State var isShowingImagePickerSheet = false

  @State var isDatePickerVisible = false
  @State private var isDailyDatePickerVisible = false

  @State private var isDismissAlertVisible = false
  @State private var isRegisterAlertVisible = false

  var privacyTypeToggleOffset: CGFloat {
    switch travelJournalEditVM.privacyType {
    case .global:
      return -90
    case .friendsOnly:
      return 0
    case .personal:
      return 90
    }
  }

  @Environment(\.dismiss) var dismiss

  // MARK: Body

  var body: some View {
    ZStack {
      Color.odya.background.normal
        .edgesIgnoringSafeArea(.bottom)

      NavigationView {
        VStack {
          ZStack {
            CustomNavigationBar(title: "여행일지 작성하기")
            HStack {
              IconButton("direction-left") {
                isDismissAlertVisible = true
              }.padding(.leading, 8)
              Spacer()
            }
          }

          ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
              TravelJournalInfoEditView(isDatePickerVisible: $isDatePickerVisible)
                .environmentObject(travelJournalEditVM)
              jounalListEditSection
              travelJournalRegisterSection
            }
            .background(Color.odya.blackopacity.baseBlackAlpha50)
          }
        }
      }

      // 여행일지 날짜 선택 뷰
      if isDatePickerVisible {
        TravelDatePickerView(
          travelJournalEditVM: travelJournalEditVM, isDatePickerVisible: $isDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }

      // 데일리 일정 날짜 선태 뷰
      if isDailyDatePickerVisible {
        DailyJournalDatePicker(
          travelJournalEditVM: travelJournalEditVM, isDatePickerVisible: $isDailyDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }
    }
    .onAppear {
      travelJournalEditVM.addDailyJournal()
    }
    .confirmationDialog("", isPresented: $isDismissAlertVisible) {
      Button("임시저장") { print("임시저장 클릭") }
      Button("작성취소", role: .destructive) {
        print("작성취소 클릭")
        dismiss()
      }
      Button("취소", role: .cancel) { print("취소 클릭") }
    } message: {
      Text("작성 중인 글을 취소하시겠습니까?\n작성 취소 선택시, 작성된 글은 저장되지 않습니다.")
    }
    .alert("작성한 여행일지를\n등록하시겠습니까?", isPresented: $isRegisterAlertVisible) {
      Button("취소") {
        isRegisterAlertVisible = false
      }
      Button("등록") {
        isRegisterAlertVisible = false
        // 검사
        if travelJournalEditVM.validateTravelJournal() {
          // api
          Task {
            await travelJournalEditVM.registerTravelJournal()
          }
          dismiss()
        }
      }
    }
  }  // body

  // MARK: Journal List Edit Section
  private var jounalListEditSection: some View {
    VStack(alignment: .leading) {
      Text("여행일지 및 사진")
        .foregroundColor(.odya.label.normal)
        .h4Style()
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 24)

      VStack(spacing: 8) {
        ForEach(travelJournalEditVM.dailyJournalList.indices, id: \.self) { index in
          DailyJournalComposeView(
            index: index,
            dailyJournal: $travelJournalEditVM.dailyJournalList[index],
            isDatePickerVisible: $isDailyDatePickerVisible
          )
          .environmentObject(travelJournalEditVM)
        }
      }
      .animation(.linear, value: travelJournalEditVM.dailyJournalList)

      if travelJournalEditVM.canAddMoreDailyJournals() {
        dailyJournalAddButton
          .padding(20)
      }
    }.background(Color.odya.background.normal)
  }

  private var dailyJournalAddButton: some View {
    Button(action: {
      travelJournalEditVM.addDailyJournal()
    }) {
      HStack(spacing: 8) {
        Image("plus-bold")
        Text("일정 추가하기")
          .b1Style()
          .foregroundColor(.odya.label.assistive)
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .cornerRadius(Radius.medium)
      .background(Color.odya.elevation.elev2)
      .overlay(
        RoundedRectangle(cornerRadius: Radius.medium)
          .strokeBorder(Color.odya.label.assistive, lineWidth: 2)
      )
    }
  }

  // MARK: Travel Journal Register Section
  private var travelJournalRegisterSection: some View {
    VStack(spacing: 8) {
      VStack(spacing: 18) {
        Text("공개 여부")
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 10)

        privacyTypeToggle
      }.padding(.vertical, 28)

      CTAButton(
        isActive: .active, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.L,
        action: {
          print("여행일지 등록하기 버튼 클릭")
          isRegisterAlertVisible = true
        }
      )
      .padding(.bottom, 28)
    }
    .padding(.horizontal, 20)
    .background(Color.odya.background.normal)
  }

  private var privacyTypeToggle: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 50)
        .frame(width: 284, height: 40)
        .foregroundColor(.odya.elevation.elev5)

      RoundedRectangle(cornerRadius: 50)
        .frame(width: 100, height: 36)
        .foregroundColor(.odya.brand.primary)
        .offset(x: privacyTypeToggleOffset)
        .animation(.easeInOut, value: travelJournalEditVM.privacyType)

      HStack(spacing: 12) {
        Button(action: {
          travelJournalEditVM.privacyType = .global
        }) {
          Text("전체공개")
            .b1Style()
            .foregroundColor(
              travelJournalEditVM.privacyType == .global
                ? .odya.label.r_normal : .odya.label.inactive
            )
            .frame(width: 59)
            .padding(10)
        }
        Button(action: {
          travelJournalEditVM.privacyType = .friendsOnly
        }) {
          Text("친구공개")
            .b1Style()
            .foregroundColor(
              travelJournalEditVM.privacyType == .friendsOnly
                ? .odya.label.r_normal : .odya.label.inactive
            )
            .frame(width: 59)
            .padding(10)
        }
        Button(action: {
          travelJournalEditVM.privacyType = .personal
        }) {
          Text("비공개")
            .b1Style()
            .foregroundColor(
              travelJournalEditVM.privacyType == .personal
                ? .odya.label.r_normal : .odya.label.inactive
            )
            .frame(width: 59)
            .padding(10)
        }
      }.frame(height: 40)
    }
  }
}

// MARK: Previews
struct TravelJournalEditView_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalComposeView()
  }
}
