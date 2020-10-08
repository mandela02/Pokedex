//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct PokemonListCellView: View {
    var firstPokemon: BasePokemonUrlResult?
    var secondPokemon: BasePokemonUrlResult?

    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 45) / 2
            let height = geometry.size.height
            HStack(alignment: .center, spacing: 10, content: {
                if let first = firstPokemon {
                    TabableCardView(updater: PokemonUpdater(url: first.url),
                                    size: (width, height))
                }
                if let second = secondPokemon {
                    TabableCardView(updater: PokemonUpdater(url: second.url),
                                    size: (width, height))
                }
            })
        })
    }
}
