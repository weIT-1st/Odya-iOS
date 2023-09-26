//
//  TravelJournalEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/17.
//

import SwiftUI

struct TravelMateView: View {
  private let mateUserData: FollowUserData
  private let status: ProfileImageStatus

  init(mate: FollowUserData) {
    self.mateUserData = mate
      if let profileColor = mate.profile.profileColor {
          self.status = .withoutImage(
            colorHex: profileColor.colorHex, name: mate.nickname)
      } else {
          self.status = .withImage(url: URL(string: mate.profile.profileUrl)!)
      }
  }

  var body: some View {
    ProfileImageView(status: status, sizeType: .XS)
  }
}

struct TravelJournalEditView: View {
  // MARK: Properties

  @EnvironmentObject var profileVM: ProfileViewModel
  @StateObject var travelJournalEditVM = TravelJournalEditViewModel()

  @State private var isDatePickerVisible = false
  @State private var isDailyDatePickerVisible = false

  private let titleCharacterLimit = 20

  @State private var isPublic: Bool = true  // 커뮤니티 공개 여부
  // @State private var isShowingAlert: Bool = false

  // MARK: Body

  var body: some View {
    ZStack {
      NavigationView {
        VStack {
          CustomNavigationBar(title: "여행일지 작성하기")
            
          ScrollView {
            VStack(spacing: 8) {
              travelInfoEditSection
              jounalListEditSection
              travelJournalRegisterSection
            }.background(Color.odya.blackopacity.baseBlackAlpha50)
          }
        }
      }

      if isDatePickerVisible {
        TravelDatePickerView(
          travelJournalEditVM: travelJournalEditVM, isDatePickerVisible: $isDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }

      if isDailyDatePickerVisible {
        DailyJournalDatePicker(
          travelJournalEditVM: travelJournalEditVM, isDatePickerVisible: $isDailyDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }
    }
    .background(Color.odya.background.normal)
    .onAppear {
      travelJournalEditVM.addDailyJournal()
    }
  }  // body

  // MARK: Travel Info Edit Section
  private var travelInfoEditSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("여행 정보")
        .foregroundColor(.odya.label.normal)
        .h4Style()

      TextField(
        "", text: $travelJournalEditVM.title,
        prompt: Text("여행일지 이름").foregroundColor(.odya.label.assistive)
      )
      .foregroundColor(.odya.label.assistive)
      .h6Style()
      .modifier(
        CustomFieldStyle(height: 45, backgroundColor: .odya.elevation.elev2, radius: Radius.small)
      )
      .onChange(of: travelJournalEditVM.title) { newValue in
        if newValue.count > titleCharacterLimit {
          travelJournalEditVM.title = String(newValue.prefix(titleCharacterLimit))
        }
      }

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

      Divider().frame(height: 1).background(Color.odya.line.alternative)

      HStack(spacing: 8) {
        Image("person-off")
        Text("함께 간 친구")
          .b2Style()
          .foregroundColor(.odya.label.normal)
        Spacer()
        travelMatesView
        NavigationLink(destination: {
            TravelMateSelectorView(token: profileVM.idToken, userId: profileVM.userID ?? -1, followCount: profileVM.followCount)
                .environmentObject(travelJournalEditVM)
            .navigationBarHidden(true)
        }) {
          Image("plus").padding(6)
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 28)
    .background(Color.odya.background.normal)
  }

  private var travelMatesView: some View {
    HStack(spacing: 0) {
      ForEach(Array(travelJournalEditVM.travelMates.prefix(3).enumerated()), id: \.element.id) {
        (index, mate) in
        TravelMateView(mate: mate)
          .offset(x: CGFloat(index * -4))
      }

      if travelJournalEditVM.travelMates.count > 3 {
        Text("외 \(travelJournalEditVM.travelMates.count - 3)명")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .frame(minWidth: 32)
          .lineLimit(1)
      }
    }
  }

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
          DailyJournalEditView(
            travelJournalEditVM: travelJournalEditVM,
            index: index,
            dailyJournal: $travelJournalEditVM.dailyJournalList[index],
            isDatePickerVisible: $isDailyDatePickerVisible)
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
      HStack {
        Text("공개 여부")
          .b1Style()
          .foregroundColor(.odya.label.normal)
        Spacer()
        Toggle(isOn: $isPublic) {}
          .toggleStyle(CustomToggleStyle())
          .frame(width: 51, height: 31)
      }
      .padding(.vertical, 28)

      CTAButton(
        isActive: .active, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.L,
        action: {
          print("여행일지 등록하기 버튼 클릭")
        }
      )
      .padding(.bottom)
    }
    .padding(.horizontal, 20)
    .background(Color.odya.background.normal)
  }
}

// MARK: Previews
struct TravelJournalEditView_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalEditView()
  }
}
