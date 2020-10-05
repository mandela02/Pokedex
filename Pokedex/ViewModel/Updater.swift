//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

class Updater: ObservableObject {
    @Published var pokemons: [PokemonUrl] = []
    
    private var canLoadMore = true
    @Published var isLoadingPage = false
    
    var url: String = UrlType.pokemons.urlString
    
    private var cancellable: AnyCancellable?
    
    private var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            if let nextURL = pokemonResult.next {
                url = nextURL
                pokemons = pokemons + pokemonResult.results.map({PokemonUrl(name: $0.name, url: $0.url)})
            } else {
                canLoadMore = false
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    init() {
        loadPokemonData()
    }
    
    func loadMorePokemonIfNeeded(current pokemon: PokemonUrl) {
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
        if pokemons.firstIndex(where: { $0.url == pokemon.url }) == thresholdIndex {
            loadPokemonData()
        }
    }
    
    func loadPokemonData() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        
        isLoadingPage = true
        
        self.cancellable = Session
            .share
            .pokemons(from: url)?
            .replaceError(with: PokemonResult())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
            })
            .assign(to: \.pokemonResult, on: self)
    }
}
