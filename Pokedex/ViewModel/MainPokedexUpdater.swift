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
    
    private var cancellables = Set<AnyCancellable>()
    private var canLoadMore = true

    var url: String = "" {
        didSet {
            loadPokemonResource()
        }
    }

    @Published var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            guard let nextURL = pokemonResult.next else {
                canLoadMore = false
                isLoadingPage = false
                isFinal = true
                return
            }
            url = nextURL
            loadPokemonsData()
        }
    }
    
    @Published var pokemons: [Pokemon] = [] {
        didSet {
            self.isLoadingPage = false
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
