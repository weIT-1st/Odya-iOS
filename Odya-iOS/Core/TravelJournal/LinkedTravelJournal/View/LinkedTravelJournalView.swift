//
//  LinkedTravelJournalView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/07.
//

import SwiftUI

struct LinkedTravelJournalView: View {
  // MARK: Properties
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = LinkedTravelJournalViewModel()
  @State private var showChangeVisibilityAlert: Bool = false

  /// 내비게이션 스택 경로
  @Binding var path: NavigationPath
  /// 선택된 여행일지 아이디
  @Binding var selectedJournalId: Int?
  /// 상위 뷰에 표시될 여행일지 타이틀
  @Binding var selectedJournalTitle: String?

  /// 헤더 뷰 타이틀
  let headerTitle: String

  // MARK: Body
  var body: some View {
    VStack {
      header

      ScrollView {
        LazyVStack(spacing: 10) {
          Section {
            if viewModel.isLoading {
              ProgressView()
            } else {
              ForEach(viewModel.state.content, id: \.journalId) { content in
                Button {
                  if content.visibility == "PRIVATE" {
                    // 공개 전환 alert toggle
                    showChangeVisibilityAlert.toggle()
                  } else {
                    if selectedJournalId == content.journalId {
                      selectedJournalId = nil
                      selectedJournalTitle = nil
                    } else {
                      selectedJournalId = content.journalId
                      selectedJournalTitle = content.title
                    }
                  }
                } label: {
                  ZStack {
                    LinkedTravelJournalCell(content: content, selectedId: $selectedJournalId)
                      .onAppear {
                        if viewModel.state.content.last?.journalId == content.journalId {
                          viewModel.fetchMyJournalListNextPageIfPossible()
                        }
                      }
                    if viewModel.isSwitchProgressing {
                      ProgressView()
                    }
                  }
                }
                // 선택된 여행일지가 비공개로 설정되어 있는 경우 alert
                .alert("해당 날짜의 여행일지를 공개로 변경할까요?", isPresented: $showChangeVisibilityAlert) {
                  Button("취소", role: .cancel) {}
                  Button {
                    // action: 공개로 변경
                    viewModel.switchVisibilityToPublic(journalId: content.journalId)
                  } label: {
                    Text("변경하기")
                      .bold()
                  }
                } message: {
                  Text("공개된 여행일지만 연동 가능합니다.")
                }
              }

            }
          }
        }.padding(.vertical, 21)
      }  // ScrollView
    }  // VStack
    .background(Color.odya.background.normal)
    .toolbar(.hidden)
    .task {
      viewModel.fetchMyJournalListNextPageIfPossible()
    }
    // 작성된 여행일지가 없는 경우 alert
    .alert("작성된 여행일지가 없어요!", isPresented: $viewModel.showNoJournalAlert) {
      Button("취소", role: .cancel) {
        dismiss()
      }
      Button {
        // action: 여행일지 작성하기
        path.removeLast(path.count)
        path.append(FeedRoute.createJournal)
      } label: {
        Text("작성하기")
      }
    } message: {
      Text("여행일지를 새로 작성하시겠습니까? 현재 작성 중인 피드 글은 사라집니다.")
    }
  }

  /// 상단 헤더
  private var header: some View {
    HStack {
      IconButton("x") {
        selectedJournalId = nil
        selectedJournalTitle = nil
        dismiss()
      }
      .frame(width: 36, height: 36)
      Spacer()
      Text(headerTitle)
        .h6Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      if selectedJournalId != nil {
        Button {
          dismiss()
        } label: {
          Text("완료")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
            .frame(width: 36, height: 36)
        }
      } else {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 36, height: 36)
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 56)

  }
}

// MARK: - Previews
//struct LinkedTravelJournalView_Previews: PreviewProvider {
//  static var previews: some View {
//    LinkedTravelJournalView(selectedJournalId: .constant(1), selectedJournalTitle: .constant("여행일지 제목"))
//  }
//}
