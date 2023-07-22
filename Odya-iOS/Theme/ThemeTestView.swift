//
//  ThemeTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/23.
//

import SwiftUI

struct ColorTestView : View {
    var body: some View {
        ScrollView {
            // brand
            Section("brand") {
                HStack {
                    resizedCircle.foregroundColor(.odya.brand.primary)
                    resizedCircle.foregroundColor(.odya.brand.secondary)
                    resizedCircle.foregroundColor(.odya.brand.tertiary)
                }
            }
            
            // system
            Section("system") {
                HStack {
                    resizedCircle.foregroundColor(.odya.system.warning)
                    resizedCircle.foregroundColor(.odya.system.warningAlternative)
                    resizedCircle.foregroundColor(.odya.system.safe)
                    resizedCircle.foregroundColor(.odya.system.safeAlternative)
                    resizedCircle.foregroundColor(.odya.system.inactive)
                }
            }
            
            // label
            Section("label") {
                HStack {
                    resizedCircle.foregroundColor(.odya.label.normal)
                    resizedCircle.foregroundColor(.odya.label.alternative)
                    resizedCircle.foregroundColor(.odya.label.assistive)
                    resizedCircle.foregroundColor(.odya.label.inactive)
                    resizedCircle.foregroundColor(.odya.label.r_normal)
                    resizedCircle.foregroundColor(.odya.label.r_assistive)
                }
            }
            
            // background
            Section("background") {
                HStack {
                    resizedCircle.foregroundColor(.odya.background.normal)
                    resizedCircle.foregroundColor(.odya.background.dimmed_system)
                    resizedCircle.foregroundColor(.odya.background.dimmed_dark)
                    resizedCircle.foregroundColor(.odya.background.dimmed_light)
                }
            }
            
            // line
            Section("line") {
                HStack {
                    resizedCircle.foregroundColor(.odya.line.normal)
                    resizedCircle.foregroundColor(.odya.line.alternative)
                }
            }
            
            // color scale
            Section("color scale") {
                HStack {
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow20)
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow30)
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow40)
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow50)
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow60)
                    resizedCircle.foregroundColor(.odya.colorscale.baseYellow70)
                }
                
                HStack {
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue20)
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue30)
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue40)
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue50)
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue60)
                    resizedCircle.foregroundColor(.odya.colorscale.baseBlue70)
                }
            }
            
            // gray scale
            Section("gray scale") {
                HStack {
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray100)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray90)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray80)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray70)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray60)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray50)
                }
                
                HStack {
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray40)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray30)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray20)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray10)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray5)
                    resizedCircle.foregroundColor(.odya.grayscale.baseGray0)
                }
            }
            
            // white opacity
            Section("white opacity") {
                HStack {
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha90)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha80)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha70)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha60)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha50)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha40)
                }
                
                HStack {
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha30)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha20)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha10)
                    resizedCircle.foregroundColor(.odya.whiteopacity.baseWhiteAlpha5)
                }
            }
            
            // black opacity
            Section("black opacity") {
                HStack {
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha90)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha80)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha70)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha60)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha50)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha40)
                }
                
                
                HStack {
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha30)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha20)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha10)
                    resizedCircle.foregroundColor(.odya.blackopacity.baseBlackAlpha5)
                }
            }
            
            
            Section("elevation") {
                HStack {
                    resizedCircle.foregroundColor(.odya.elevation.elev1)
                    resizedCircle.foregroundColor(.odya.elevation.elev2)
                    resizedCircle.foregroundColor(.odya.elevation.elev3)
                    resizedCircle.foregroundColor(.odya.elevation.elev4)
                    resizedCircle.foregroundColor(.odya.elevation.elev5)
                    resizedCircle.foregroundColor(.odya.elevation.elev6)
                }
            }
        }
        .padding()
        .background(Color.odya.background.normal)
        .padding()
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
        Section("version 1.0") {
            HStack {
                VStack {
                    IconButton("location-m") {print("location-m")}
                    IconButton("location-s", size: 20) {print("location-s")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                
                VStack {
                    IconButton("eye-on") {print("eye-on")}
                    IconButton("eye-off") {print("eye-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("alarm-on") {print("alarm-on")}
                    IconButton("alarm-off") {print("alarm-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("messages-on") {print("messages-on")}
                    IconButton("messages-off") {print("messages-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                
                VStack {
                    IconButton("person-on") {print("person-on")}
                    IconButton("person-off") {print("person-off")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
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
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("bookmark-off") {print("bookmark-off")}
                    IconButton("bookmark-on") {print("bookmark-on")}
                    IconButton("bookmark-yellow") {print("bookmark-yellow")}
                }
                .frame(width: 64, height: 134)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("star-off") {print("star-off")}
                    IconButton("star-on") {print("star-on")}
                    IconButton("star-yellow") {print("star-yellow")}
                }
                .frame(width: 64, height: 134)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
                
                VStack {
                    IconButton("menu-hamburger") {print("menu-hamburger")}
                    IconButton("menu-kebob") {print("menu-kebob")}
                    IconButton("menu-meatballs") {print("menu-meatballs")}
                }
                .frame(width: 64, height: 134)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
            }
            
            HStack {
                IconButton("comment") {print("reply")}
                IconButton("diary") {print("diary")}
                IconButton("share") {print("share")}
                IconButton("search") {print("search")}
                IconButton("person-plus") {print("person-plus")}
                IconButton("plus") {print("plus")}
                IconButton("setting") {print("setting")}
            }
            .frame(maxWidth: .infinity)
            .background(Color.odya.background.normal)
            .padding(.vertical, 10)
            .cornerRadius(Radius.small)
            
            Section("version 1.1") {
                HStack {
                    VStack {
                        HStack {
                            IconButton("list") {print("list")}
                            IconButton("grid") {print("grid")}
                            IconButton("trip") {print("trip")}
                        }
                        HStack {
                            IconButton("check") {print("check")}
                            IconButton("gps") {print("gps")}
                            IconButton("exclaim") {print("exclaim")}
                        }
                        HStack {
                            IconButton("alarm") {print("alarm")}
                            IconButton("reply") {print("reply")}
                            IconButton("information") {print("information")}
                        }
                    }
                    .padding()
                    .background(Color.odya.background.normal)
                    .cornerRadius(Radius.small)
                    
                    VStack {
                        IconButton("pencil-m") {print("pencil-m")}
                        IconButton("pencil-s", size: 20) {print("pencil-s")}
                    }
                    .frame(width: 64, height: 95)
                    .background(Color.odya.background.normal)
                    .cornerRadius(Radius.small)
                    
                    VStack {
                        IconButton("heart-off-m") {print("heart-off-m")}
                        IconButton("heart-on-l") {print("heart-on-l")}
                        IconButton("heart-on-s") {print("heart-on-s")}
                        IconButton("heart-off-s") {print("heart-off-s")}
                    }
                    .frame(width: 64, height: 166)
                    .background(Color.odya.background.normal)
                    .cornerRadius(Radius.small)
                }
            }
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


