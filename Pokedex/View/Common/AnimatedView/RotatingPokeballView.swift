//
//  RotatingPokeballView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/7/20.
//

import SwiftUI

struct RotatingPokeballView: View {
    @State private var isAnimating = false
    
    var color: Color = Color.white.opacity(0.3)
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image("ic_pokeball")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
            .onAppear {
                withAnimation(foreverAnimation) {
                    self.isAnimating = true
                }
            }.onDisappear {
                withAnimation(nil) {
                    self.isAnimating = false
                }
            }.blur(radius: 2)
    }
}
