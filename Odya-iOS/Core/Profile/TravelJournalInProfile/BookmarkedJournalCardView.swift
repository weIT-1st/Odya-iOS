//
//  BookmarkedJournalCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct BookmarkedJournalCardView: View {
  @EnvironmentObject var VM: JournalsInProfileViewModel
  @StateObject var bookmarkManager = JournalBookmarkManager()
  
  let journalId: Int
  let title: String
  let dateString: String
  let writer: Writer
  let imageUrl: String
  @State private var isBookmarked: Bool
  
  init(_ journal: BookmarkedJournalData) {
    self.journalId = journal.journalId
    self.title = journal.title
    self.dateString = journal.startDateString
    self.writer = journal.writer
    self.imageUrl = journal.mainImageUrl
    self._isBookmarked = State(initialValue: journal.isBookmarked)
  }
  
  var body: some View {
    ZStack {
      AsyncImageView(url: imageUrl,
                     width: 232, height: 200,
                     cornerRadius: Radius.medium)
        .overlay {
          Color.odya.background.dimmed_light
        }
      
      VStack {
        HStack {
          Text(title)
            .b1Style()
            .foregroundColor(.odya.label.normal)
            .lineLimit(1)
          Spacer()
          StarButton(isActive: isBookmarked, isYellowWhenActive: true) {
            bookmarkManager.setBookmarkState(isBookmarked, journalId) { result in
              isBookmarked = result
              VM.updateBookmarkedJournals()
            }
          }
        }
        
        Spacer()
        
        HStack(spacing: 8) {
          ProfileImageView(of: writer.nickname,
                           profileData: writer.profile,
                           size: .S)
          Text(writer.nickname)
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Spacer()
          Text(dateString)
            .detail2Style()
            .foregroundColor(.odya.label.assistive)
        }
        
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 15)
    }
    .frame(width: 232, height: 200)
  }
}


//struct BookmarkedJOurnalCardView_Previews: PreviewProvider {
//  static var previews: some View {
//    BookmarkedJournalCardView()
//  }
//}

