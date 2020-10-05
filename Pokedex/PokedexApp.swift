//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(updater: Updater())
                .padding(.all, 10)
        }
    }
}
