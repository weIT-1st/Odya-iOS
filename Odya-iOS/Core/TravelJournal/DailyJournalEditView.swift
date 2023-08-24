//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import SwiftUI

struct DailyJournalEditView: View {
    
    // MARK: Properties
    
    @ObservedObject var travelJournalEditVM: TravelJournalEditViewModel
    
    let index: Int
    @Binding var dailyJournal: DailyTravelJournal
    @Binding var isDatePickerVisible: Bool
    
    private var dayIndexString: String {
        let dayIndex = dailyJournal.getDayIndex(startDate: travelJournalEditVM.startDate)
        return dayIndex == 0 ? "Day " : "Day \(dayIndex)"
    }

    private let contentCharacterLimit = 200

    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 16) {
            headerBar
            selectedImageList
            selectedDate
            journalConent
            taggedLocation
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .cornerRadius(Radius.medium)
        .background(Color.odya.elevation.elev2)
    }
    
    // MARK: Header bar
    private var headerBar: some View {
        HStack(spacing: 8) {
            Image("sparkle-m")
            Text(dayIndexString)
                .h4Style()
                .foregroundColor(.odya.brand.primary)
            
            Spacer()
            
            Button(action: {
                travelJournalEditVM.deleteDailyJournal(dailyJournal: dailyJournal)
            }) {
                Text("삭제하기")
                    .font(Font.custom("Noto Sans KR", size: 14))
                    .underline()
                    .foregroundColor(.odya.label.assistive)
            }.padding(.trailing, 8)
            
            // TODO: 꾹 눌러서 이동하는 기능 추가
            IconButton("menu-hamburger-l") {
                print("이동 버튼 클릭")
            }.colorMultiply(Color.odya.label.assistive)
        }
    }

    // MARK: Selected Image List
    // TODO: 이미지 추가 기능 및 선택된 이미지 화면에 표시
    private var selectedImageList: some View {
        HStack {
            Button(action: {
                print("이미지 추가 버튼 클릭")
            }) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 120, height: 120)
                    .background(Color.odya.elevation.elev5)
                    .cornerRadius(Radius.small)
                    .overlay(
                        VStack(spacing: 0) {
                            Image("camera")
                            Text("2/15")
                                .detail2Style()
                                .foregroundColor(.odya.label.assistive)
                        }
                    )
            }
            Spacer()
        }
    }

    // MARK: Selected Date
    private var selectedDate: some View {
        HStack(spacing: 0) {
            Image("calendar")
                .colorMultiply(.odya.label.assistive)
            Button(action: {
                travelJournalEditVM.pickedJournalIndex = index
                isDatePickerVisible = true
            }) {
                HStack {
                    if let date = dailyJournal.date {
                        TravelDateEditView(date: date)
                    } else {
                        Text("날짜를 선택해주세요!")
                            .b1Style()
                    }
                    Spacer()
                }
                .padding(12)
                .frame(height: 48)
            }.foregroundColor(.odya.label.assistive)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(Color.odya.elevation.elev4)
        .cornerRadius(Radius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.medium)
                .inset(by: 0.5)
                .stroke(Color.odya.line.alternative, lineWidth: 1)
        )

    }

    // MARK: Content
    private var journalConent: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("pen-s")
                .colorMultiply(.odya.label.assistive)
            TextField("", text: $dailyJournal.content,
                      prompt: Text("여행일지를 작성해주세요! (최대 \(contentCharacterLimit)자)").foregroundColor(.odya.label.assistive),
                      axis: .vertical)
            .foregroundColor(.odya.label.assistive)
            .b1Style()
            .frame(minHeight: 90, alignment: .top)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.odya.elevation.elev4)
        .cornerRadius(Radius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.medium)
                .inset(by: 0.5)
                .stroke(Color.odya.line.alternative, lineWidth: 1)
        )
        .onChange(of: dailyJournal.content) { newValue in
            if newValue.count > contentCharacterLimit {
                dailyJournal.content = String(newValue.prefix(contentCharacterLimit))
            }
        }
    }

    private var taggedLocation: some View {
        HStack(spacing: 0) {
            Image("location-m")
                .colorMultiply(.odya.label.assistive)
            Button(action: {
                print("장소 태그하기 버튼 클릭")
            }) {
                HStack(spacing: 12) {
                    Text("장소 태그하기")
                        .b1Style()
                    Spacer()
                }
                .padding(12)
                .frame(height: 48)
            }.foregroundColor(.odya.label.assistive)
        }
        .padding(12)
        .frame(height: 48)
        .background(Color.odya.elevation.elev4)
        .cornerRadius(Radius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.medium)
                .inset(by: 0.5)
                .stroke(Color.odya.line.alternative, lineWidth: 1)
        )
    }
}


struct DailyJournal_Previews: PreviewProvider {
    static var previews: some View {
        DailyJournalEditView(travelJournalEditVM: TravelJournalEditViewModel(), index: 0, dailyJournal: .constant(DailyTravelJournal()), isDatePickerVisible: .constant(false))
    }
}
