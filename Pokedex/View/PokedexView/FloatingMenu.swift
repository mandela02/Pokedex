//
//  FloatingMenu.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import SwiftUI

struct FloatingMenu: View {
    @State var showSubButton = false
    
    @State var pressed = false
    @Binding var selectedMenu: Int
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 30) {
            VStack(alignment: .trailing, spacing: 30) {
                Spacer()
                if showSubButton {
                    ForEach(SubViewKind.allCases.reversed(), id: \.self) { kind in
                        MenuItem(icon: kind.image, text: kind.name, tag: kind.rawValue, selected: $selectedMenu)
                            .animation(Animation.default.delay(Double(kind.rawValue)/10))
                            .onTapGesture {
                                withAnimation(Animation.spring().delay(0.4)) {
                                    selectedMenu = kind.rawValue
                                    pressed = false
                                }
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
        showSubButton.toggle()
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
        .overlay(
            Capsule(style: .circular)
                .stroke(Color.red, lineWidth: 3)
                .padding(EdgeInsets(top: -10, leading: -20, bottom: -10, trailing: -20))
        )
        .padding(.trailing, 30)
    }
}
