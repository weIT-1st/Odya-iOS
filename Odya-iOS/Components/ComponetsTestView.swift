//
//  ComponetsTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

struct IconTestView : View {
    var body : some View {
        ScrollView {
            Section("version 1.0") {
                HStack {
                    VStack {
                        IconButton("location-m") {print("location-m")}
                        IconButton("location-s") {print("location-s")}
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
            }
            
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
                        IconButton("pen-m") {print("pen-m")}
                        IconButton("pen-s") {print("pen-s")}
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

struct SystemTestView: View {
    var body: some View {
        ScrollView {
            Section("version 1.1") {
                VStack {
                    IconButton("system-warning") {print("system-warning")}
                    IconButton("system-check-circle") {print("system-check-circle")}
                }
                .frame(width: 64, height: 95)
                .background(Color.odya.background.normal)
                .cornerRadius(Radius.small)
            }
        }
    }
}

struct ButtonTestView: View {
    
    @State private var isOn: Bool = false
    @State private var state: checkboxState = .unselected
    @State private var isFollowing: Bool = false
    
    var body: some View {
        ScrollView {
            Section("version 1.0") {
                HStack {
                    // toggle
                    HStack {
                        Toggle(isOn: $isOn) {}
                            .toggleStyle(CustomToggleStyle())
                            .frame(width: 51, height: 31)
                        
                        Spacer()
                        Text(isOn ? "Active" : "Inactive")
                    }.frame(width: 130).padding(.trailing, 20)
                    
                    // checkbox
                    HStack {
                        CheckboxButton(state: $state)
                        
                        Spacer()
                        switch state{
                        case .disabled:
                            Text("disabled")
                        case .unselected:
                            Text("unselected")
                        case .selected:
                            Text("selected")
                        }
                    }.frame(width: 120)
                }
            } // section version 1.0
            
            Section("version 1.1") {
                VStack {
                    HStack {
                        VStack {
                            WriteButton() { print("write button clicked") }
                        }
                        
                        // small grey button
                        VStack {
                            IconButton("smallGreyButton-x", action: {print("smallGreyButtonx")})
                            IconButton("smallGreyButton-send", action: { print("ssmallGreyButtonsend")})
                        }
                        
                        VStack {
                            IconButton("smallGreyButton-?-m") {print("smallGreyButton?-m")}
                            IconButton("smallGreyButton-?-s") { print("smallGreyButton-?-s")}
                        }
                        
                        VStack {
                            HStack {
                                FollowButton(isFollowing: isFollowing, buttonStyle: .solid, action: {
                                    isFollowing.toggle()
                                })
                                FollowButton(isFollowing: isFollowing, buttonStyle: .ghost, action: {
                                    isFollowing.toggle()
                                })
                            }
                            
                            EditButton(action: {print("편집하기")})
                            
                        }
                    }
                    
                    CTAButton(isActive: .active, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.L, action: {print("등록하기 L")})
                    CTAButton(isActive: .active, buttonStyle: .ghost, labelText: "등록하기", labelSize: ComponentSizeType.L, action: {print("등록하기 L")})
                    CTAButton(isActive: .inactive, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.L, action: {print("등록하기 L")})
                    CTAButton(isActive: .active, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.M, action: {print("등록하기 M")})
                    CTAButton(isActive: .active, buttonStyle: .solid, labelText: "등록하기", labelSize: ComponentSizeType.S, action: {print("등록하기 S")})
                    
                }
                
            } // section version 1.1
        }
    }
}

struct BadgeTestView: View {
    var body: some View {
        VStack {
            Image("sparkle-m")
            Image("sparkle-s")
        }
        .frame(width: 64, height: 95)
        .background(Color.odya.background.normal)
        .cornerRadius(Radius.small)
    }
}

struct ComponentsTestView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: IconTestView(), label: {
                    Text("Icons")
                })
                NavigationLink(destination: SystemTestView(), label: {
                    Text("System")
                })
                NavigationLink(destination: ButtonTestView(), label: {
                    Text("Button")
                })
                NavigationLink(destination: BadgeTestView(), label: {
                    Text("Badge")
                })
            }
        }
    }
    
}

struct ComponentsTestView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsTestView()
    }
}
