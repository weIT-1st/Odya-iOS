//
//  ThemeTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/23.
//

import SwiftUI

struct ColorTestView : View {
    var body: some View {
        VStack {
            HStack {
                resizedCircle.foregroundColor(.brandColor.primary)
                resizedCircle.foregroundColor(.brandColor.secondary)
                resizedCircle.foregroundColor(.brandColor.tertiary)
            }
            
            HStack {
                resizedCircle.foregroundColor(.colorScale.yellow20)
                resizedCircle.foregroundColor(.colorScale.yellow30)
                resizedCircle.foregroundColor(.colorScale.yellow40)
                resizedCircle.foregroundColor(.colorScale.yellow50)
                resizedCircle.foregroundColor(.colorScale.yellow60)
                resizedCircle.foregroundColor(.colorScale.yellow70)
            }
            
            HStack {
                resizedCircle.foregroundColor(.colorScale.blue20)
                resizedCircle.foregroundColor(.colorScale.blue30)
                resizedCircle.foregroundColor(.colorScale.blue40)
                resizedCircle.foregroundColor(.colorScale.blue50)
                resizedCircle.foregroundColor(.colorScale.blue60)
                resizedCircle.foregroundColor(.colorScale.blue70)
            }
            
            HStack {
                resizedCircle.foregroundColor(.system.warning)
                resizedCircle.foregroundColor(.system.warningAlternative)
                resizedCircle.foregroundColor(.system.safe)
                resizedCircle.foregroundColor(.system.safeAlternative)
                resizedCircle.foregroundColor(.system.inactive)
            }
            
            HStack {
                resizedCircle.foregroundColor(.background.normal)
                resizedCircle.foregroundColor(.background.dimmed)
            }
            
            HStack {
                resizedCircle.foregroundColor(.label.normal)
                resizedCircle.foregroundColor(.label.alternative)
                resizedCircle.foregroundColor(.label.assistive)
                resizedCircle.foregroundColor(.label.inactive)
                resizedCircle.foregroundColor(.label.r_normal)
                resizedCircle.foregroundColor(.label.r_assistive)
            }
            
            HStack {
                resizedCircle.foregroundColor(.line.normal)
                resizedCircle.foregroundColor(.line.alternative)
            }
            
            HStack {
                resizedCircle.foregroundColor(.elevation.elev1)
                resizedCircle.foregroundColor(.elevation.elev2)
                resizedCircle.foregroundColor(.elevation.elev3)
                resizedCircle.foregroundColor(.elevation.elev4)
                resizedCircle.foregroundColor(.elevation.elev5)
                resizedCircle.foregroundColor(.elevation.elev6)
            }
        }
        .padding()
        .background(Color.background.normal)
    }
    var resizedCircle : some View {
        Circle()
            .frame(width: 50, height: 50)
    }
}

struct TextStyleTestView : View {
    var body: some View {
        VStack {
            Text("H1").h1Style()
            Text("H2").h2Style()
            Text("H3").h3Style()
            Text("H4").h4Style()
            Text("H5").h5Style()
            Text("H6").h6Style()
            Text("B1").b1Style()
            Text("B2").b2Style()
            Text("DETAIL 1").detail1Style()
            Text("DETAIL 2").detail2Style()
        }
    }
}

struct ShadowTestView : View {
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .cardShadow()
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .floatingButtonShadow()
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .profileShadow()
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .dropBoxShadow()
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 120, height: 120)
                .foregroundColor(.white)
                .etcShadow()
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color.white)
    }
}

struct IconTestView : View {
    var body : some View {
        VStack {
            HStack {
                VStack {
                    IconButton("location-m") {print("location-m")}
                    IconButton("location-s") {print("location-s")}
                }
                .frame(width: 64, height: 95)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("eye-on") {print("eye-on")}
                    IconButton("eye-off") {print("eye-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("alarm-on") {print("alarm-on")}
                    IconButton("alarm-off") {print("alarm-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("messages-on") {print("messages-on")}
                    IconButton("messages-off") {print("messages-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                
                VStack {
                    IconButton("person-on") {print("person-on")}
                    IconButton("person-off") {print("person-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
            }
            
            HStack(alignment: .top) {
                VStack {
                    IconButton("direction-left") {print("direction-left")}
                    IconButton("direction-right") {print("direction-right")}
                    IconButton("direction-down") {print("direction-down")}
                    IconButton("direction-up") {print("direction-up")}
                }
                .frame(width: 64, height: 166)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("heart-off") {print("heart-off")}
                    IconButton("heart-on") {print("heart-on")}
                    IconButton("heart-yellow") {print("heart-yellow")}
                }
                .frame(width: 64, height: 134)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("bookmark-off") {print("bookmark-off")}
                    IconButton("bookmark-on") {print("bookmark-on")}
                    IconButton("bookmark-yellow") {print("bookmark-yellow")}
                }
                .frame(width: 64, height: 134)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("star-off") {print("star-off")}
                    IconButton("star-on") {print("star-on")}
                    IconButton("star-yellow") {print("star-yellow")}
                }
                .frame(width: 64, height: 134)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("menu-hamburger") {print("menu-hamburger")}
                    IconButton("menu-kebob") {print("menu-kebob")}
                    IconButton("menu-meatballs") {print("menu-meatballs")}
                }
                .frame(width: 64, height: 134)
                .background(Color.background.normal)
                .cornerRadius(Radius.small)
            }
            HStack {
                IconButton("reply") {print("reply")}
                IconButton("diary") {print("diary")}
                IconButton("share") {print("share")}
                IconButton("search") {print("search")}
                IconButton("person-plus") {print("person-plus")}
                IconButton("plus") {print("plus")}
                IconButton("setting") {print("setting")}
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.background.normal)
            .cornerRadius(Radius.small)
        }.padding(.horizontal, GridLayout.side)
    }
}
    

struct ThemeTestView : View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ColorTestView(), label: {
                    Text("Color")
                })
                NavigationLink(destination: TextStyleTestView(), label: {
                    Text("TextStyle")
                })
                NavigationLink(destination: ShadowTestView(), label: {
                    Text("Shadow")
                })
                NavigationLink(destination: IconTestView(), label: {
                    Text("Icons")
                })
            }
        }
    }
    
    
}

struct ThemeTestView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeTestView();
    }
}


