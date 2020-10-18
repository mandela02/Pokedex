//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct AllPokemonList: View {    
    @StateObject var updater: Updater = Updater()
    @State var isLoading = false
    @State var isFinal = false
    @State var isFirstTimeLoadView = true
    
    var body: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = (geometry.size.width - 20) / 2 * 0.7
            PokemonList(cells: $updater.pokemonsCells,
                        isLoading: $isLoading,
                        isFinal: $updater.isFinal,
                        paddingHeader: 50,
                        paddingFooter: 50,
                        cellSize: CGSize(width: geometry.size.width, height: height)) { item in
                updater.loadMorePokemonIfNeeded(current: item)
            }
            .onReceive(updater.$isLoadingPage, perform: { isLoading in
                withAnimation(Animation.spring()) {
                    if isLoading {
                        self.isLoading = true
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isLoading = false
                        }
                    }
                }
            })
            .onReceive(updater.$isFinal, perform: { isFinal in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(Animation.spring()) {
                        self.isFinal = isFinal
                    }
                }
            })
            .onAppear {
                if isFirstTimeLoadView {
                    self.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(Animation.spring()) {
                            updater.url = UrlType.pokemons.urlString
                        }
                    }
                }
                isFirstTimeLoadView = false
            }
        })
    }
}
