//
//  Profile.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/26.
//

import SwiftUI

struct ProfileColor {
    private static let colors: [String: Color] = [
        "#2D3238": Color.odya.elevation.elev6,
        "#979DA3": Color.odya.system.inactive,
        "#FFD41F": Color.odya.colorscale.baseYellow50,
        "#BB9701": Color.odya.colorscale.baseYellow60,
        "#FFFAE8": Color.odya.colorscale.baseYellow20,
        "#001A77": Color.odya.colorscale.baseBlue70,
        "#0028BB": Color.odya.colorscale.baseBlue60,
        "#0037FF": Color.odya.colorscale.baseBlue50
    ]
    
    static func getColor(from hexCode: String) -> Color? {
        return colors[hexCode]
    }
}

enum ProfileImageStatus {
    case withoutImage(colorHex: String, name: String)
    case withImage(url: URL)
}

struct ProfileImageView: View {
    let status: ProfileImageStatus
    let sizeType: ComponentSizeType
    
    var size: CGFloat {
        return sizeType.ProfileImageSize
    }
    
    init(of nickname: String, profileData: ProfileData, size: ComponentSizeType) {
        if let profileColor = profileData.profileColor {
            self.status = .withoutImage(colorHex: profileColor.colorHex, name: nickname)
        } else {
            self.status = .withImage(url: URL(string: profileData.profileUrl)!)
        }
        self.sizeType = size
    }
    
    init(profileUrl: String, size: ComponentSizeType) {
      if let url = URL(string: profileUrl) {
        self.status = .withImage(url: url)
      } else {
        self.status = .withoutImage(colorHex: "", name: "")
      }
      self.sizeType = size
    }
    
    var body: some View {
        switch status {
        case .withoutImage(let colorHex, let name):
            switch sizeType {
            case .XS:
                let color = ProfileColor.getColor(from: colorHex)
                Circle()
                    .fill(color ?? Color.odya.elevation.elev6)
                    .frame(width: ComponentSizeType.XS.ProfileImageSize, height: ComponentSizeType.XS.ProfileImageSize)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .foregroundColor(.white)
                            .detail1Style()
                    )
            default:
                Image("profile")
                    .resizable()
                    .frame(width: size, height: size)
            }
        case .withImage(let url):
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipped()
                        .background(Color.odya.system.inactive) // 갑자기 기본 이미지 배경이 투명해져서.. 임시방편으로 채워줬습니다
                        .cornerRadius(size / 2)
                } else if phase.error != nil {
                    Image("profile")
                        .frame(width: size, height: size)
                } else {
                    ProgressView()
                        .frame(width: size, height: size)
                        .cornerRadius(size / 2)
                }
                
            }
        }
    }
}

//struct ProfileImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileImageView(status: .withoutImage(colorHex: "#FFD41F", name: "손희오"), sizeType: .L)
////        ProfileImageView(status: .withImage(url: URL(string: "https://image.tmdb.org/t/p/w500//r2J02Z2OpNTctfOSN1Ydgii51I3.jpg")!), sizeType: .L)
//    }
//}
