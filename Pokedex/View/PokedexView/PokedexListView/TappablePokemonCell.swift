//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

struct TappablePokemonCell: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>

    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater
    @State var show: Bool = false
    @State var isFavorite = false

    let pokedexCellModel: PokedexCellModel
    let size: CGSize
    
    var body: some View {
        TapToPushView(show: $show) {
            PokedexCardView(url: pokedexCellModel.pokemonUrl, size: size)
                .contextMenu(menuItems: {
                    Button(action: {
                        if isFavorite {
                            CoreData.dislike(pokemon: pokedexCellModel.pokemonUrl)
                        } else {
                            CoreData.like(pokemonUrl: pokedexCellModel.pokemonUrl,
                                          speciesUrl: pokedexCellModel.speciesUrl)
                        }
                    }) {
                        Text(isFavorite ? "Remove from favorite" : "Add To favorite")
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                })
        } destination: {
            ParallaxView(pokedexCellModel: pokedexCellModel, isShowing: $show)
                .environmentObject(reachabilityUpdater)
        }.buttonStyle(PlainButtonStyle())
        .onAppear(perform: {
            isFavorite = favorites.map({$0.pokemonUrl}).contains(pokedexCellModel.pokemonUrl)
        }).onChange(of: favorites.count, perform: { value in
            isFavorite = favorites.map({$0.pokemonUrl}).contains(pokedexCellModel.pokemonUrl)
        })
    }
}
