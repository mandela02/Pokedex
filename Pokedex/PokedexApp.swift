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
            PokedexView()
                .statusBar(hidden: true)
        }
    }
}

struct PokedexView: View {
    var body: some View {
        ZStack {
            PokemonListView(updater: Updater())
                .ignoresSafeArea(.container, edges: .bottom)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

struct PokedexApp_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
