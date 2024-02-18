//
//  ToggleButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    let onColor = Color.odya.brand.primary
    let offColor = Color.odya.system.inactive
    let size = CGSize(width: 51, height: 31)
    
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return HStack {
            configuration.label
            Spacer()
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: size.height / 2)
                    .fill(isOn ? onColor : offColor)
                Circle()
                    .foregroundColor(.white)
                    .dropBoxShadow()
                    .padding(2)
            }
            .frame(width: size.width, height: size.height)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

// MARK: Noti Setting Toggle
struct NotiToggleButton: View {
  @Binding var notiSetting: NotificationSetting
  
  var body: some View {
    Toggle(isOn: $notiSetting.isOn) {
      HStack {
        Spacer()
        Text(notiSetting.title)
          .b1Style()
          .foregroundColor(.odya.label.assistive)
          .padding(.trailing, 24)
      }.frame(height: 36)
    }.toggleStyle(CustomToggleStyle())
  }
}
