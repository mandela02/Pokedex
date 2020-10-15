//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct PokemonPairCell: View {
    @EnvironmentObject var voiceUpdater: VoiceHelper

    var firstPokemon: NamedAPIResource?
    var secondPokemon: NamedAPIResource?
    
    @State var show: Bool = false

    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 45) / 2
            let height = geometry.size.height
            HStack(alignment: .center, spacing: 10, content: {
                if let first = firstPokemon {
                    let firstUpdater = PokemonUpdater(url: first.url)
                    TappablePokemonCell(updater: firstUpdater, show: $show, size: CGSize(width: width, height: height))
                }
                if let second = secondPokemon {
                    let secondUpdater = PokemonUpdater(url: second.url)
                    TappablePokemonCell(updater: secondUpdater, show: $show, size: CGSize(width: width, height: height))
                }
            })
            .buttonStyle(PlainButtonStyle())
        })
    }
}

struct TappablePokemonCell: View {
    let updater: PokemonUpdater
    @Binding var show: Bool
    let size: CGSize
    var body: some View {
        TapToPushView(show: $show) {
            PokedexCardView(updater: updater, size: (size.width, size.height))
        } destination: {
            PokemonInformationView(updater: updater, isShowing: $show)
        }
    }
}
