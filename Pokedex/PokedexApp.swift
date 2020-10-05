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
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.red, .yellow, .blue]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                PokemonListView(updater: Updater())
                    .padding(.all, 10)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
    }
}
