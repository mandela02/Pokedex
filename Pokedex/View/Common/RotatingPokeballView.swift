//
//  RotatingPokeballView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/7/20.
//

import SwiftUI

struct RotatingPokeballView: View {
    @State private var isAnimating = false
    
    var color: Color
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        GeometryReader (content: { geometry in
            let size = geometry.size
            
            VStack(content: {
                Spacer()
                Image(uiImage: UIImage(named: "ic_pokeball")!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                    .animation(self.isAnimating ? foreverAnimation : .default)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            withAnimation(foreverAnimation) {
                                self.isAnimating = true
                            }
                        })
                     }
                    .onDisappear {
                        withAnimation(.default) {
                            self.isAnimating = false
                        }
                    }
                Rectangle().fill(Color.clear)
                    .frame(height: abs(size.height/2 - 55), alignment: .center)
            })
        })
    }
}
