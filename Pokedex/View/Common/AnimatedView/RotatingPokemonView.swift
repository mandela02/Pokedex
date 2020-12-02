//
//  RotatingPokemonView.swift
//  Pokedex
//
//  Created by TriBQ on 23/11/2020.
//

import SwiftUI

struct RotatingPokemonView: View {
    var message: String?
    var image: String?
    var background: Color

    var pokemons = Constants.pokemons
    @State var isAnimated = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background.opacity(0.5)
                if let image = image {
                    image.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                } else if let message = message {
                    Text(message)
                        .font(Biotif.bold(size: 20).font)
                        .foregroundColor(.red)
                }
                let offset = 0 - (geometry.size.width / 2 - 50)
                ForEach(Array(zip(pokemons.indices, pokemons)), id: \.0) { index, item in
                    item.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(0 - Double(index) * 30))
                        .rotationEffect(.degrees(isAnimated ? 0 : 360))
                        .offset(y: offset)
                        .rotationEffect(.degrees(Double(index) * 30))
                }.rotationEffect(.degrees(isAnimated ? 360 : 0))
                .onAppear {
                    withAnimation(Animation.linear(duration: 18).repeatForever(autoreverses: false)) {
                        isAnimated = true
                    }
                }.onDisappear {
                    isAnimated = false
                }
            }
        }
    }
}
