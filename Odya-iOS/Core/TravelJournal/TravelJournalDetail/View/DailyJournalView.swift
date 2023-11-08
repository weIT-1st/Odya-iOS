//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

struct SplarkleIcon: View {
  var body: some View {
    Image("sparkle-filled")
      .shadow(color: .odya.brand.primary.opacity(0.8), radius: 9, x: 0, y: 0)
  }
}

struct DailyJournalView: View {
    @EnvironmentObject var journalDetailVM: TravelJournalDetailViewModel

    let journalId: Int
  let dailyJournal: DailyJournal
  let dateString: String
  let content: String
  let placeName: String
  let placeLoc: String
  var images: [DailyJournalImage] = []

  var displayedImages: [DailyJournalImage] {
    if isExpanded {
      return images
    } else {
      return isFeedType ? Array(images.prefix(2)) : Array(images.prefix(9))
    }
  }

  @Binding var isFeedType: Bool
  @Binding var isAllExpanded: Bool
  @Binding var isEditViewShowing: Bool

  @State var isExpanded: Bool = false
  @State private var isShowingImagePickerSheet: Bool = false
  @State private var isDatePickerVisible: Bool = false
  @State private var isShowingJournalDeletionAlert: Bool = false
    @State private var isShowingJournalDeletionFailureAlert: Bool = false
    @State private var failureMessage: String = ""

  let imageListWidth: CGFloat = UIScreen.main.bounds.width - GridLayout.side * 2 - 50  // 50 = DayN VStack width

  init(
    journalId: Int, dailyJournal: DailyJournal, isFeedType: Binding<Bool>,
    isAllExpanded: Binding<Bool>, isEditViewShowing: Binding<Bool>
  ) {
      self.journalId = journalId
      self.dailyJournal = dailyJournal
      self._isFeedType = isFeedType
      self._isAllExpanded = isAllExpanded
      self._isEditViewShowing = isEditViewShowing
      
      self.dateString = dailyJournal.travelDate.dateToString(format: "yyyy.MM.dd")
    self.content = dailyJournal.content
    self.placeName = "덕수궁 돌담길"
    self.placeLoc = "서울특별시 중구"
    self.images = dailyJournal.images
  }

  var body: some View {
      ZStack {
          VStack(spacing: 16) {
              HStack(spacing: 10) {
                  Button(action: {
                      isExpanded.toggle()
                  }) {
                      HStack {
                          Text(dateString)
                              .b1Style()
                              .foregroundColor(.odya.label.assistive)
                          Spacer()
                          Image(isExpanded ? "direction-up" : "direction-down")
                      }.frame(height: 36)
                  }
                  
                  Menu {
//                      NavigationLink("편집하기", destination: ContentEditView(dailyJournal: dailyJournal, isShowingImagePickerSheet: $isShowingImagePickerSheet, isDatePickerVisible: $isDatePickerVisible))
                      Button("편집하기") {
//                          isEditViewShowing = true
                          print("edit")
                      }
                      Button("삭제하기", role: .destructive) {
                          isShowingJournalDeletionAlert = true
                      }
                  } label: {
                      Image("menu-kebob")
                  }
              }
              
              Divider().frame(height: 1).background(Color.odya.line.alternative)
              
              // content
              HStack {
                  Text(content)
                      .detail2Style()
                      .foregroundColor(.odya.label.normal)
                      .lineLimit(isExpanded ? nil : 2)
                  Spacer()
              }
              
              // image list
              if isFeedType {
                  imageFeedView
              } else {
                  ImageGridView(
                    images: displayedImages.map { $0.imageUrl }, totalWidth: imageListWidth, spacing: 3)
              }
              
              placeInfo
          }
          .padding(.bottom, 40)
          .animation(.easeInOut, value: isExpanded)
          .onChange(of: isAllExpanded) { newValue in
              isExpanded = newValue
              
          }
          
//          if isEditViewShowing {
//              ContentEditView(dailyJournal: dailyJournal, isShowingImagePickerSheet: $isShowingImagePickerSheet, isDatePickerVisible: $isDatePickerVisible)
//                  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//          }
      }.alert("해당 날짜의 여행일지를 삭제할까요?", isPresented: $isShowingJournalDeletionAlert) {
          HStack {
            Button("취소", role: .cancel) {
                isShowingJournalDeletionAlert = false
            }
            Button("삭제", role: .destructive) {
                isShowingJournalDeletionAlert = false
                journalDetailVM.deleteDailyJournal(journalId: journalId, dailyJournalId: dailyJournal.dailyJournalId) { success, errMsg in
                    if success {
                        print("delete")
                    } else {
                        failureMessage = errMsg
                        isShowingJournalDeletionFailureAlert = true
                    }
                    
                }
            }
          }
        } message: {
          Text("삭제된 내용은 복구될 수 없습니다.")
        }
        .alert(failureMessage, isPresented: $isShowingJournalDeletionFailureAlert) {
            Button("확인") {
                isShowingJournalDeletionFailureAlert = false
                failureMessage = ""
            }
        }

  }

  private var imageFeedView: some View {
    VStack(spacing: 15) {
      ForEach(displayedImages, id: \.id) { anImage in
        AsyncImage(url: URL(string: anImage.imageUrl)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageListWidth, height: imageListWidth * 0.65)
            .cornerRadius(Radius.small)
        } placeholder: {
          ProgressView()
            .frame(width: imageListWidth)
        }

      }
    }
  }

  private var placeInfo: some View {
    HStack {
      HStack(spacing: 7) {
        Image("location-m")
          .renderingMode(.template)
          .resizable()
          .frame(width: 12, height: 12)
        Text(placeName)
          .detail2Style()
      }.foregroundColor(.odya.brand.primary)
      Spacer()
      Text(placeLoc)
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
    }
  }

}

struct MyPreviewProvider_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalDetailView(journalId: 1)
  }
}
