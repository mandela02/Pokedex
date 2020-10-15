//
//  PulsatingPlayButton.swift
//  Pokedex
//
//  Created by TriBQ on 12/10/2020.
//

import SwiftUI

struct PulsatingPlayButton: View {
    @State private var pulstate: Bool = false
    @State private var showWaves: Bool = false
    @Binding private var isSpeaking: Bool
    @Binding private var pokemon: Pokemon

    private var size: CGFloat = 50

    var pulstateAnimation: Animation {
        return Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)
                        .speed(1)
    }
    
    var waveAnimation: Animation {
        return Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: false)
                        .speed(1)
    }
    
    init(isSpeaking: Binding<Bool>, about pokemon: Binding<Pokemon>) {
        self._isSpeaking = isSpeaking
        self._pokemon = pokemon
        self.pulstate = isSpeaking.wrappedValue
        self.showWaves = isSpeaking.wrappedValue
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: size, height: size)
                .foregroundColor(isSpeaking ? pokemon.mainType.color.background : .clear)
                .scaleEffect(showWaves ? 2 : 1)
                .hueRotation(.degrees(showWaves ? 360 : 0))
                .opacity(showWaves ? 0 : 1)
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(pokemon.mainType.color.background)
            Image(systemName: isSpeaking ? "speaker.slash" : "speaker.2")
                .font(.largeTitle)
                .foregroundColor(pokemon.mainType.color.text)
                .scaleEffect(0.7)
        }
        .shadow(radius: 26)
        .onTapGesture {
            withAnimation(.spring()) {
                self.isSpeaking.toggle()
            }
        }
        .onChange(of: isSpeaking, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                withAnimation(pulstateAnimation) {
                    self.pulstate = value
                }
                withAnimation(waveAnimation) {
                    self.showWaves = value
                }
            })
        })
    }
}
