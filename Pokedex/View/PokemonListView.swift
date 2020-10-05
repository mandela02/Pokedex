//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokemonListView: View {
    @ObservedObject var updater: Updater

    var body: some View {
        GeometryReader(content: { geometry in
            let width = (geometry.size.width - 10) / 2
            let height: CGFloat = geometry.size.height / 6
            let gridItem = GridItem(.fixed(width), spacing: 10)
            let columns = Array(repeating: gridItem, count: 2)
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(updater.pokemons, id: \.self.id) { pokemon in
                        PokedexCardView(pokemon: pokemon, size: (width, height))
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            }).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        })
        
    }
}
