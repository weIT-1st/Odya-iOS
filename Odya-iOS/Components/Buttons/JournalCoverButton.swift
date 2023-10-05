//
//  JournalCoverButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/05.
//

import SwiftUI

/// 여행일지 더보기 버튼
extension View {
    func JournalCoverButton(profileImageUrl: URL?,
                            labelText: String?,
                            coverImageUrl: URL,
                            journalTitle: String,
                            isHot: Bool,
                            action: @escaping () -> Void)
    -> some View  {
        Button(action: action) {
            VStack {
                HStack(spacing: 12) {
                    // profile image
                    if let url = profileImageUrl {
                        AsyncImage(url: url)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    // label text (ex. 여행일지 더보기)
                    Text(labelText ?? "")
                        .h6Style()
                        .foregroundColor(Color.odya.label.normal)
                    Spacer()
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Spacer()
                    // icon
                    Image("diary")
                        .frame(width: 24, height: 24)
                    // journal title
                    Text(journalTitle)
                        .detail1Style()
                        .foregroundColor(Color.odya.label.alternative)
                    // hot
                    if isHot {
                        Text("HOT🔥")
                            .font(.custom("NotoSansKR-Bold", size: 8))
                            .foregroundColor(Color.odya.label.alternative)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.small)
                                    .foregroundColor(Color.odya.system.warning)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                AsyncImage(url: coverImageUrl, content: { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .overlay(Color.odya.background.dimmed_system)
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                })
            )
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .cornerRadius(Radius.medium)
        }
    }
}
