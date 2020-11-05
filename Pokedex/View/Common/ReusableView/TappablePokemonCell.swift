//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct TappablePokemonCell: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    let pokemon: Pokemon
    
    @State var show: Bool = false
    
    let size: CGSize
    var body: some View {
        TapToPushView(show: $show) {
            PokedexCardView(pokemon: pokemon, size: (size.width, size.height))
                .contextMenu(menuItems: {})
        } destination: {
            ParallaxView(pokemonUrl: UrlType.getPokemonUrl(of: pokemon.pokeId), isShowing: $show)
                .environmentObject(reachabilityUpdater)
            //PokemonInformationView(pokemon: pokemon, isShowing: $show)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
