//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct AllPokemonList: View {
    @EnvironmentObject var reachabilityUpdater: ReachabilityUpdater

    @StateObject var updater = MainPokedexUpdater()
    @State var isLoading = false
    @State var isFinal = false
    @State var isFirstTimeLoadView = true

    var body: some View {
        PokemonList(cells: updater.pokemonUrls,
                    isLoading: $updater.isLoadingPage,
                    isFinal: $updater.isFinal,
                    paddingHeader: 50,
                    paddingFooter: 50,
                    onCellAppear: { pokemon in
                        updater.loadMorePokemonIfNeeded(current: pokemon)
                    })
            .onAppear {
                updater.isTopView = true
                if isFirstTimeLoadView {
                    updater.url = UrlType.species.urlString
                    isFirstTimeLoadView = false
                }
            }.onDisappear {
                updater.isTopView = false
            }.showAlert(error: $updater.error)
    }
}
