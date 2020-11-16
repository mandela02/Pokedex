//
//  ParallaxPokemonsList.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/26/20.
//

import SwiftUI

struct ParallaxPokemonsList: View {
    var pokemons: [String]
    
    let numberOfColumns: CGFloat = Constants.deviceIdiom == .pad ? 3 : 2
    
    private func calculateGridItem(width: CGFloat) -> [GridItem] {
        let gridItem = GridItem(.fixed(width), spacing: 10)
        return Array(repeating: gridItem, count: Int(numberOfColumns))
    }
    
    var body: some View {
        GeometryReader { reader in
            let width = (reader.size.width - 80) / numberOfColumns
            let height = width * 0.7
            LazyVGrid(columns: calculateGridItem(width: width)) {
                ForEach(pokemons) { cell in
                    TappablePokemonCell(url: cell, size: CGSize(width: width, height: height))
                        .background(Color.clear)
                }
            }.animation(.linear)
        }
    }
}
