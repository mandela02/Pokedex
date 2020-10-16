//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct PokemonPairCell: View {
    var firstPokemon: NamedAPIResource?
    var secondPokemon: NamedAPIResource?
    
    @State var showFirst: Bool = false
    @State var showSecond: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 45) / 2
            let height = geometry.size.height
            HStack(alignment: .center, spacing: 10, content: {
                if let first = firstPokemon {
                    TappablePokemonCell(updater: PokemonUpdater(url: first.url), show: $showFirst, size: CGSize(width: width, height: height))
                }
                if let second = secondPokemon {
                    TappablePokemonCell(updater: PokemonUpdater(url: second.url), show: $showSecond, size: CGSize(width: width, height: height))
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
        .onChange(of: show) { _ in
            print(updater.pokemon.name)
        }
    }
}
