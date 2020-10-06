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
        }
    }
}

struct PokedexView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .yellow, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .blur(radius: 3)
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
