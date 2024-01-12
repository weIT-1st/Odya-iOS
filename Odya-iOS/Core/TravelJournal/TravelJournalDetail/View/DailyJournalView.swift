//
//  DailyJournalView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

struct DailyJournalView: View {

  @EnvironmentObject var journalDetailVM: TravelJournalDetailViewModel

  // journal data
  let journal: TravelJournalDetailData
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
      return journalDetailVM.isFeedType ? Array(images.prefix(2)) : Array(images.prefix(9))
    }
  }

  let imageListWidth: CGFloat = UIScreen.main.bounds.width - GridLayout.side * 2 - 50  // 50 = DayN VStack width

  /// 데일리 일정 내용이 펼쳐져 있는지 여부
  @State private var isExpanded: Bool = false

  @State private var isShowingEditView: Bool = false

  /// 데일리 일정 삭제 확인 알림 화면 표시 여부
  @State private var isShowingJournalDeletionAlert: Bool = false

  // 데일리 일정 삭제 실패 시 뜨는 알림 화면 표시 여부
  @State private var isShowingJournalDeletionFailureAlert: Bool = false

  /// 데일리 일정 삭제 실패 메시지
  @State private var failureMessage: String = ""

  init(journal: TravelJournalDetailData, dailyJournal: DailyJournal) {
    self.journal = journal
    self.journalId = journal.journalId
    self.dailyJournal = dailyJournal

    self.dateString = dailyJournal.travelDate.dateToString(format: "yyyy.MM.dd")
    self.content = dailyJournal.content
    self.placeName = "덕수궁 돌담길"
    self.placeLoc = "서울특별시 중구"
    self.images = dailyJournal.images
  }

  var body: some View {
    VStack(spacing: 16) {
      // date & menu bar
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

        if journalDetailVM.isMyJournal {
          Menu {
            Button("편집하기") {
              print("edit")
              isShowingEditView = true
            }
            Button("삭제하기", role: .destructive) {
              isShowingJournalDeletionAlert = true
            }
          } label: {
            IconButton("menu-kebob") {}
          }
          .fullScreenCover(isPresented: $isShowingEditView) {
            DailyJournalEditView(journal: journal, editedJournal: dailyJournal)
          }
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
      if journalDetailVM.isFeedType {
        imageFeedView
      } else {
        ImageGridView(
          images: displayedImages.map { $0.imageUrl }, totalWidth: imageListWidth, spacing: 3)
      }

      placeInfo
    }
    .padding(.bottom, 40)
    .animation(.easeInOut, value: isExpanded)
    .onChange(of: journalDetailVM.isAllExpanded) { newValue in
      isExpanded = newValue
    }
    .alert("해당 날짜의 여행일지를 삭제할까요?", isPresented: $isShowingJournalDeletionAlert) {
      HStack {
        Button("취소", role: .cancel) {
          isShowingJournalDeletionAlert = false
        }
        Button("삭제", role: .destructive) {
          isShowingJournalDeletionAlert = false
          journalDetailVM.deleteDailyJournal(
            journalId: journalId, dailyJournalId: dailyJournal.dailyJournalId
          ) { success, errMsg in
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

  /// 피드 형식일 때 이미지 뷰
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
