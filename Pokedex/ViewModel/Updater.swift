//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

struct PokemonCell: Identifiable, Equatable {
    static func == (lhs: PokemonCell, rhs: PokemonCell) -> Bool {
        lhs.firstPokemon?.url == rhs.firstPokemon?.url
    }
    
    var id = UUID().uuidString
    var firstPokemon: PokemonUrl?
    var secondPokemon: PokemonUrl?
}

class Updater: ObservableObject {
    @Published var pokemons: [PokemonUrl] = []
    @Published var pokemonsCells: [PokemonCell] = [PokemonCell()]

    
    private var canLoadMore = true
    @Published var isLoadingPage = false
    
    var url: String = UrlType.pokemons.urlString
    
    private var cancellable: AnyCancellable?
    
    private var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            guard let nextURL = pokemonResult.next else {
                canLoadMore = false
                return
            }
            let result = pokemonResult.results.map({PokemonUrl(name: $0.name, url: $0.url)})
            pokemons = pokemons + result
            url = nextURL
            result.enumerated().forEach { item in
                if item.offset % 2 == 0 {
                    let newPokemons = PokemonCell(firstPokemon: item.element, secondPokemon: result[safe: item.offset + 1])
                    pokemonsCells.append(newPokemons)
                }
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    init() {
        loadPokemonData()
    }
    
    func loadMorePokemonIfNeeded(current pokemonCell: PokemonCell) {
        let thresholdIndex = pokemonsCells.index(pokemonsCells.endIndex, offsetBy: -5)
        if pokemonsCells.firstIndex(where: { $0 == pokemonCell }) == thresholdIndex {
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
