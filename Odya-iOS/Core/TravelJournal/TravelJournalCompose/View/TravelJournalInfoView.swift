//
//  TravelJournalInfoView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/31.
//

import SwiftUI

// MARK: Travel Info Edit Section
struct TravelJournalInfoEditView: View {
  @EnvironmentObject var journalComposeVM: JournalComposeViewModel

  private let titleCharacterLimit = 20

  @State var isDatePickerVisible = false

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
      "", text: $journalComposeVM.title,
      prompt: Text("여행일지 이름")
        .foregroundColor(.odya.label.assistive)
    )
    .foregroundColor(
      (journalComposeVM.title == journalComposeVM.orgTitle)
        ? .odya.label.assistive : .odya.label.normal
    )
    .h6Style()
    .modifier(
      CustomFieldStyle(height: 45, backgroundColor: .odya.elevation.elev2, radius: Radius.small)
    )
    .onChange(of: journalComposeVM.title) { newValue in
      if newValue.count > titleCharacterLimit {
        journalComposeVM.title = String(newValue.prefix(titleCharacterLimit))
      }
    }
  }

  /// 여행 시작/마지막 날짜 선택
  private var travelDateEditField: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 12) {
        Image("date-start")
        Image("date-end")
      }
      .colorMultiply(.odya.brand.primary)

      Button(action: { isDatePickerVisible = true }) {
        VStack(alignment: .leading, spacing: 12) {
          TravelDateEditView(date: journalComposeVM.startDate)
          TravelDateEditView(date: journalComposeVM.endDate)
        }.padding(.horizontal, 12)
      }
      // 여행일지 날짜 선택 뷰
      .fullScreenCover(isPresented: $isDatePickerVisible) {
        TravelDatePickerView(
          journalComposeVM: journalComposeVM, isDatePickerVisible: $isDatePickerVisible
        )
        .padding(GridLayout.side)
        .frame(maxHeight: .infinity)
        .clearModalBackground()
        .background(Color.odya.blackopacity.baseBlackAlpha80)
      }
    }.padding(.horizontal, 12)
  }

  /// 함께 간 친구
  private var travelMatesEditField: some View {
    HStack(spacing: 8) {
      Image("person-off")
      Text("함께 간 친구")
        .b2Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      travelMatesView
      NavigationLink(destination: {
        TravelMateSelectorView()
          .environmentObject(journalComposeVM)
          .navigationBarHidden(true)
      }) {
        Image("plus").padding(6)
      }
    }
  }

  /// 선택된 함깨 간 친구
  private var travelMatesView: some View {
    HStack(spacing: 0) {
      ForEach(Array(journalComposeVM.travelMates.prefix(3).enumerated()), id: \.element.id) {
        (index, mate) in
        let profileData = ProfileData(
          profileUrl: mate.profileUrl ?? "",
          profileColor: mate.profileColor)
        ProfileImageView(
          of: mate.nickname ?? "",
          profileData: profileData,
          size: .XS
        )
        .offset(x: CGFloat(index * -4))
      }

      if journalComposeVM.travelMates.count > 3 {
        Text("외 \(journalComposeVM.travelMates.count - 3)명")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .frame(width: 33)
          .lineLimit(1)
      }
    }
  }
}
