//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

class MainPokedexUpdater: ObservableObject {
    @Published var isLoadingPage = false
    @Published var isFinal = false
    @Published var settings = UserSettings()

    private var cancellables = Set<AnyCancellable>()
    private var canLoadMore = true

    init
    
    var url: String = "" {
        didSet {
            loadPokemonResource()
        }
    }

    @Published var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            if pokemonResult.count != settings.speciesCount {
                settings.speciesCount = pokemonResult.count
            }
            if let nextUrl = pokemonResult.next {
                url = nextUrl
            } else {
                canLoadMore = false
                isFinal = true
            }
            loadPokemonsData()
        }
    }
    
    @Published var pokemons: [Pokemon] = [] {
        didSet {
            self.isLoadingPage = false
            isFinal = pokemonResult.next == nil
        }
    }
            
    func loadMorePokemonIfNeeded(current pokemon: Pokemon) {
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
        if pokemons.firstIndex(where: { $0.pokeId == pokemon.pokeId}) == thresholdIndex {
            loadPokemonResource()
        }
    }
    
    private func loadPokemonResource() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        
        isLoadingPage = true
        
        Session
            .share
            .pokemons(from: url)
            .replaceError(with: PokemonResult())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemonResult, on: self)
            .store(in: &cancellables)
    }
    
    private func loadPokemonsData() {
        let pokemonUrls = pokemonResult.results.map({UrlType.getPokemonUrl(of: StringHelper.getPokemonId(from: $0.url))})
        Publishers.MergeMany(pokemonUrls.map({Session.share.pokemon(from: $0)}))
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] pokemons in
                guard let self = self else { return }
                self.pokemons = self.pokemons + pokemons.sorted(by: {$0.pokeId < $1.pokeId})
            }
            .store(in: &cancellables)
    }
}
