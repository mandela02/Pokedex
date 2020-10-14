//
//  FloatingMenu.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct FloatingMenu: View {
    @State var showMenuItem1 = false
    @State var showMenuItem2 = false
    @State var showMenuItem3 = false
    
    @State var pressed = false
    @Binding var active: Int
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 30) {
            VStack(alignment: .trailing, spacing: 30) {
                Spacer()
                if showMenuItem1 {
                    MenuItem(icon: "camera", text: "Nothing yet", tag: 2, selected: $active)
                        .animation(Animation.default.delay(0.2))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                active = 2
                            }
                        }
                }
                if showMenuItem2 {
                    MenuItem(icon: "photo.on.rectangle", text: "Type", tag: 1, selected: $active)
                        .animation(Animation.default.delay(0.1))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                active = 1
                            }
                        }
                }
                if showMenuItem3 {
                    MenuItem(icon: "square.and.arrow.up", text: "National Dex", tag: 0, selected: $active)
                        .animation(Animation.default.delay(0))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                active = 0
                            }
                        }
                }
            }
            HamburgerButtonView(pressed: $pressed)
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
                .shadow(radius: 26)
                .onChange(of: pressed, perform: { value in
                    showMenuAnimated()
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
        }
    }
    
    func showMenuAnimated() {
        showMenuItem3.toggle()
        showMenuItem2.toggle()
        showMenuItem1.toggle()
    }
}


struct MenuItem: View {
    var icon: String
    var text: String
    var tag: Int
    @Binding var selected: Int
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .renderingMode(.template)
                .imageScale(.large)
                .foregroundColor(selected == tag ? .white : .red)
            Text(text)
                .font(.custom("Biotif-SemiBold", size: 15))
                .foregroundColor(selected == tag ? .white : .red)
        }
        .frame(height: 20, alignment: .trailing)
        .shadow(radius: 26)
        .transition(AnyTransition.move(edge: .trailing))
        .background(Capsule(style: .circular)
                        .fill(selected == tag ? Color.red : Color.white)
                        .padding(EdgeInsets(top: -10, leading: -20, bottom: -10, trailing: -20)))
        .padding(.trailing, 30)
    }
}
