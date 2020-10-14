//
//  HamburgerButtonView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/14/20.
//

import SwiftUI

struct HamburgerButtonView: View {
    @Binding var pressed: Bool

    var body: some View {
        ZStack {
            Circle().fill(Color.red)
            VStack(alignment: .center, spacing: 5) {
                Rectangle().fill(Color.white).frame(width: 30, height: 5)
                    .cornerRadius(4)
                    .rotationEffect(.degrees(pressed ? 45 : 0), anchor: .leading)
                    .offset(x: pressed ? 5 : 0)
                Rectangle().fill(Color.white).frame(width: 30, height: 5)
                    .cornerRadius(4)
                    .scaleEffect(pressed ? 0 : 1)
                    .opacity(pressed ? 0 : 1)
                    .offset(x: pressed ? 5 : 0)
                Rectangle().fill(Color.white).frame(width: 30, height: 5)
                    .cornerRadius(4)
                    .rotationEffect(.degrees(pressed ? -45 : 0), anchor: .leading)
                    .offset(x: pressed ? 5 : 0)
            }.animation(.interpolatingSpring(stiffness: 300, damping: 15))
        }
        .onTapGesture(count: 1, perform: {
            pressed.toggle()
        })
    }
}
//
//struct HamburgerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        HamburgerButtonView()
//    }
//}
