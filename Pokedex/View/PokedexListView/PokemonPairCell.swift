//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct PokemonPairCell: View {
    @EnvironmentObject var environment: EnvironmentUpdater

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
                    TappablePokemonCell(updater: PokemonUpdater(url: first.url),
                                        show: $showFirst,
                                        size: CGSize(width: width, height: height))
                        .environmentObject(environment)
                }
                if let second = secondPokemon {
                    TappablePokemonCell(updater: PokemonUpdater(url: second.url),
                                        show: $showSecond,
                                        size: CGSize(width: width, height: height))
                        .environmentObject(environment)
                }
            })
            .buttonStyle(PlainButtonStyle())
        })
    }
}

struct TappablePokemonCell: View {
    @EnvironmentObject var environment: EnvironmentUpdater

    let updater: PokemonUpdater
    @Binding var show: Bool
    let size: CGSize
    var body: some View {
        Button {
            environment.selectedPokemon = updater.pokemonUrl ?? ""
        } label: {
            PokedexCardView(updater: updater, size: (size.width, size.height))
        }
    }
}
