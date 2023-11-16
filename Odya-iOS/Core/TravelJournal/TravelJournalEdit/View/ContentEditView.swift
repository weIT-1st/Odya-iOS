//
//  ContentEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/08.
//

import Photos
import SwiftUI

/// 여행일지 데일리 일정 내용 수정 뷰
/// 사진, 날짜, 텍스트내용, 위치 수정 가능
struct ContentEditView: View {
  @EnvironmentObject var journalEditVM: DailyJournalEditViewModel
  
  /// 갤러리 접근 권한
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized

  /// 갤러리 접근 권한이 거부되었을 때 알림 표시 여부
  @State private var isShowingImagesPermissionDeniedAlert = false
    
  /// 데일리 일정 날짜 선택 뷰가 화면에 표시되고 있는지 여부
  @Binding var isDatePickerVisible: Bool
  
  /// 이미지 피커가 현재 화면에 표시되고 있는지 여부
  @Binding var isShowingImagePickerSheet: Bool
    
  /// 텍스트내용 글자 제한 200자
  private let contentCharacterLimit = 200

  // journal data
  @Binding var date: Date
  @Binding var content: String
  @Binding var placeId: String?
  @Binding var latitudes: [Double]
  @Binding var longitudes: [Double]
  @Binding var fetchedImages: [DailyJournalImage]
  @Binding var selectedImages: [ImageData]
  
  
  // MARK: Body
    
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
          if fetchedImages.count + selectedImages.count < 15 {
              imageAddButton
          }
          
          ForEach(selectedImages) { imageData in
              Button(action: {
                  selectedImages = selectedImages.filter {
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
          
          ForEach(fetchedImages) { imageData in
              Button(action: {
                  fetchedImages = fetchedImages.filter {
                      $0.id != imageData.id
                  }
              }) {
                  ZStack {
                      AsyncImage(url: URL(string: imageData.imageUrl)!) { image in
                          image
                              .resizable()
                              .scaledToFill()
                              .frame(width: 120, height: 120)
                              .cornerRadius(Radius.small)
                      } placeholder: {
                          ProgressView()
                              .frame(height: 120)
                      }
                      Image("smallGreyButton-x-filled")
                          .offset(x: 55, y: -57.5)
                          .frame(width: 0, height: 0)
                  }
              }
          }
        Spacer()
      }.padding(.vertical, 16)
            .animation(.easeInOut, value: selectedImages)
            .animation(.easeInOut, value: fetchedImages)
    }
  }
    
    /// 이미지 추가 버튼
    /// 선택된 사진이 15장 미만일 때 나타남
    private var imageAddButton: some View {
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
                        Text("\(fetchedImages.count + selectedImages.count)/15")
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

  // MARK: Selected Date
  private var selectedDate: some View {
    HStack(spacing: 0) {
      Image("calendar")
        .colorMultiply(.odya.label.assistive)
      Button(action: {
        isDatePickerVisible = true
      }) {
        HStack {
          TravelDateEditView(date: date)
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
        "", text: $content,
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
    .onChange(of: content) { newValue in
      if newValue.count > contentCharacterLimit {
          content = String(newValue.prefix(contentCharacterLimit))
      }
    }
  }

  // MARK: Tagged Location
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

//struct ContentEditView_Previews: PreviewProvider {
//  static var previews: some View {
//      DailyJournalEditView(
//          dayN: 1, dailyJournal: .constant(DailyJournal())
//      )
//
//    //        DailyJournalContentEditView(index: 1, dailyJournal: .constant(DailyTravelJournal()), isDatePickerVisible: .constant(false))
//  }
//}

