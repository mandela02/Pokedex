//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct TappablePokemonCell: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @State var show: Bool = false

    let url: String
    let size: CGSize
    
    var body: some View {
        TapToPushView(show: $show) {
            PokedexCardView(url: url, size: size)
                .contextMenu(menuItems: {})
        } destination: {
            ParallaxView(pokemonUrl: url, isShowing: $show)
                .environmentObject(reachabilityUpdater)
        }.buttonStyle(PlainButtonStyle())
    }
}