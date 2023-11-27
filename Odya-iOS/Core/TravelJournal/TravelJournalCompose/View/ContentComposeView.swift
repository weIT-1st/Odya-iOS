//
//  DailyJornalContentEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/15.
//

import Photos
import SwiftUI

struct ContentComposeView: View {

  @EnvironmentObject var journalComposeVM: JournalComposeViewModel

  let index: Int
  @Binding var dailyJournal: DailyTravelJournal

  // image
  @Binding var isShowingImagePickerSheet: Bool
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized

  // date
  @Binding var isDatePickerVisible: Bool

  // content
  private let contentCharacterLimit = 200

  // place

  // alert
  @State private var isShowingDailyJournalDeleteAlert = false
  @State private var isShowingImagesPermissionDeniedAlert = false

  var body: some View {
    VStack(spacing: 0) {
      selectedImageList

      VStack(spacing: 16) {
        selectedDate
        journalConent
        taggedLocation
      }
    }
  }

  // MARK: Selected Image List
  private var selectedImageList: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 10) {
        if dailyJournal.selectedImages.count < 15 {
          Button(action: {
            let requiredAccessLevel: PHAccessLevel = .readWrite
            PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
              imageAccessStatus = authorizationStatus
              switch authorizationStatus {
              case .authorized, .limited:
                isShowingImagePickerSheet = true
              case .denied, .restricted:
                // 권한이 거부된 경우 앱 설정으로 이동 제안
                isShowingImagesPermissionDeniedAlert = true
              default:
                break
              }
            }
          }) {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 120, height: 120)
              .background(Color.odya.elevation.elev5)
              .cornerRadius(Radius.small)
              .overlay(
                VStack(spacing: 0) {
                  Image("camera")
                  Text("\(dailyJournal.selectedImages.count)/15")
                    .detail2Style()
                    .foregroundColor(.odya.label.assistive)
                }
              )
          }
          .alert("사진 액세스 권한 거부", isPresented: $isShowingImagesPermissionDeniedAlert) {
            HStack {
              Button("취소") {
                isShowingImagesPermissionDeniedAlert = false
              }
              Button("설정으로 이동") {
                isShowingImagesPermissionDeniedAlert = false
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                  UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
              }
            }
          } message: {
            Text("사진 액세스 권한이 거부되었습니다. 설정 앱으로 이동하여 권한을 다시 설정하십시오.")
          }
        }

        ForEach(dailyJournal.selectedImages) { imageData in
          Button(action: {
            dailyJournal.selectedImages = dailyJournal.selectedImages.filter {
              $0.assetIdentifier != imageData.assetIdentifier
            }
          }) {
            ZStack {
              Image(uiImage: imageData.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .cornerRadius(Radius.small)
              Image("smallGreyButton-x-filled")
                .offset(x: 55, y: -57.5)
                .frame(width: 0, height: 0)
            }
          }
        }
        Spacer()
      }.padding(.vertical, 16)
        .animation(.easeInOut, value: dailyJournal.selectedImages)
    }
  }

  // MARK: Selected Date
  private var selectedDate: some View {
    HStack(spacing: 0) {
      Image("calendar")
        .colorMultiply(.odya.label.assistive)
      Button(action: {
        journalComposeVM.pickedJournalIndex = index
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
      TextField(
        "", text: $dailyJournal.content,
        prompt: Text("여행일지를 작성해주세요! (최대 \(contentCharacterLimit)자)").foregroundColor(
          .odya.label.assistive),
        axis: .vertical
      )
      .foregroundColor(.odya.label.normal)
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

struct ContentComposeView_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalComposeView()

    //        DailyJournalContentEditView(index: 1, dailyJournal: .constant(DailyTravelJournal()), isDatePickerVisible: .constant(false))
  }
}
