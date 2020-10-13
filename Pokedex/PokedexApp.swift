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
                .environmentObject(VoiceHelper())
        }
    }
}

struct PokedexView: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry  in
                let size = geometry.size
                
                RotatingPokeballView(color: .red)
                    .ignoresSafeArea()
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .offset(x: size.width * 1/4 + 25, y: -size.height * 2/5)

                PokemonListView(updater: Updater())
                    .ignoresSafeArea(.container, edges: .bottom)
                    .ignoresSafeArea(.container, edges: .top)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

            }
        }
    }
}

struct PokedexApp_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
