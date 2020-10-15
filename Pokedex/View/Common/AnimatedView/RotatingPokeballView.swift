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
        GeometryReader (content: { geometry in
            let size = geometry.size
            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center, spacing: 0 ,content: {
                    Spacer()
                    Image("ic_pokeball")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(color)
                        .frame(width: size.width * 2/3, height: size.width * 2/3, alignment: .center)
                        .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                        .onAppear {
                            withAnimation(foreverAnimation) {
                                self.isAnimating = true
                            }
                         }
                        .onDisappear {
                            withAnimation(.default) {
                                self.isAnimating = false
                            }
                        }
                        .offset(y: -abs(size.height/2 - 55))
                        .frame(minWidth: 0, idealWidth: .infinity, alignment: .center)
                        .blur(radius: 2)
                    Spacer()
                })
            }
        })
    }
}
