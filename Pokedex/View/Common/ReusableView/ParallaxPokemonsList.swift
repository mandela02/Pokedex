//
//  ParallaxPokemonsList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/26/20.
//

import SwiftUI

struct ParallaxPokemonsList: View {
    var pokemons: [PokedexCellModel]
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    var width: CGFloat {
        return (UIScreen.main.bounds.width - 80) / numberOfColumns
    }
    var height: CGFloat {
        width * 0.7
    }
    
    private func calculateGridItem() -> [GridItem] {
        let gridItem = GridItem(.fixed(width), spacing: 10)
        return Array(repeating: gridItem, count: Int(numberOfColumns))
    }
    
    var body: some View {
        LazyVGrid(columns: calculateGridItem()) {
            ForEach(pokemons) { cell in
                TappablePokemonCell(pokedexCellModel: cell, size: CGSize(width: width, height: height))
                    .background(Color.clear)
            }
        }.animation(.linear)
    }
}
