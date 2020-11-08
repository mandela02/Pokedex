//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct AllPokemonList: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    @StateObject var updater: MainPokedexUpdater = MainPokedexUpdater()
    @State var isLoading = false
    @State var isFinal = false
    @State var isFirstTimeLoadView = true

    var body: some View {
        PokemonList(cells: $updater.pokemonUrls,
                    isLoading: $isLoading,
                    isFinal: $isFinal,
                    paddingHeader: 50,
                    paddingFooter: 50,
                    onCellAppear: { pokemon in
                        if updater.isTopView {
                            updater.loadMorePokemonIfNeeded(current: pokemon)
                        }
                    })
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
            }).onReceive(updater.$isFinal, perform: { isFinal in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(Animation.spring()) {
                        self.isFinal = isFinal
                    }
                }
            }).onAppear {
                updater.isTopView = true
                if isFirstTimeLoadView {
                    self.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(Animation.spring()) {
                            updater.url = UrlType.species.urlString
                        }
                    }
                }
                isFirstTimeLoadView = false
            }.onDisappear {
                updater.isTopView = false
            }.showAlert(error: $updater.error)
    }
}
