//
//  FloatingMenu.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct FloatingMenu: View {
    @State var showFirstMenu = false
    @State var showSecondMenu = false
    @State var showThirdMenu = false
    @State var showFourthMenu = false

    @State var pressed = false
    @Binding var active: Int
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 30) {
            VStack(alignment: .trailing, spacing: 30) {
                Spacer()
                if showFourthMenu {
                    MenuItem(icon: "car", text: "Favorite", tag: 3, selected: $active)
                        .animation(Animation.default.delay(0.3))
                        .onTapGesture {
                            toggleMenu()
                            withAnimation(Animation.spring().delay(0.4)) {
                                active = 3
                            }
                        }
                }

                if showThirdMenu {
                    MenuItem(icon: "camera", text: "All Type", tag: 2, selected: $active)
                        .animation(Animation.default.delay(0.2))
                        .onTapGesture {
                            toggleMenu()
                            withAnimation(Animation.spring().delay(0.4)) {
                                active = 2
                            }
                        }
                }
                if showSecondMenu {
                    MenuItem(icon: "photo.on.rectangle", text: "All Gen", tag: 1, selected: $active)
                        .animation(Animation.default.delay(0.1))
                        .onTapGesture {
                            toggleMenu()
                            withAnimation(Animation.spring().delay(0.4)) {
                                active = 1
                            }
                        }
                }
                if showFirstMenu {
                    MenuItem(icon: "square.and.arrow.up", text: "Search", tag: 0, selected: $active)
                        .animation(Animation.default.delay(0))
                        .onTapGesture {
                            toggleMenu()
                            withAnimation(Animation.spring().delay(0.4)) {
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
                    toggleMenu()
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
        }
    }
    
    func toggleMenu() {
        showFourthMenu.toggle()
        showThirdMenu.toggle()
        showSecondMenu.toggle()
        showFirstMenu.toggle()
    }
}


struct MenuItem: View {
    var icon: String
    var text: String
    var tag: Int
    @Binding var selected: Int
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(text)
                .font(Biotif.semiBold(size: 12).font)
                .foregroundColor(selected == tag ? .white : .red)
            Image(systemName: icon)
                .renderingMode(.template)
                .imageScale(.large)
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
