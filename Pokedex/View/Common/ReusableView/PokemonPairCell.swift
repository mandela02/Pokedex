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
                TappablePokemonCell(updater: PokemonUpdater(url: firstPokemon?.url ?? ""),
                                    show: $showFirst,
                                    size: CGSize(width: width - 10, height: height))
                    .environmentObject(environment)
                    .isHidden(firstPokemon == nil)
                TappablePokemonCell(updater: PokemonUpdater(url: secondPokemon?.url ?? ""),
                                    show: $showSecond,
                                    size: CGSize(width: width - 10, height: height))
                    .environmentObject(environment)
                    .isHidden(secondPokemon == nil)
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 10)
            .padding(.trailing, 10)
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
