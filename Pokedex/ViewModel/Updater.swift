//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

struct PokemonCellModel: Identifiable, Equatable {
    static func == (lhs: PokemonCellModel, rhs: PokemonCellModel) -> Bool {
        lhs.firstPokemon?.url == rhs.firstPokemon?.url
    }
    
    var id = UUID().uuidString
    var firstPokemon: NamedAPIResource?
    var secondPokemon: NamedAPIResource?
}

class Updater: ObservableObject {
    @Published var pokemons: [NamedAPIResource] = []
    @Published var pokemonsCells: [PokemonCellModel] = []

    
    private var canLoadMore = true
    @Published var isLoadingPage = false
    @Published var isFinal = false

    var url: String = "" {
        didSet {
            loadPokemonData()
        }
    }
    
    private var cancellable: AnyCancellable?
    
    private var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            guard let nextURL = pokemonResult.next else {
                canLoadMore = false
                isLoadingPage = false
                isFinal = true
                return
            }
            let result = pokemonResult.results.map({NamedAPIResource(name: $0.name, url: $0.url)})
            pokemons = pokemons + result
            url = nextURL
            result.enumerated().forEach { item in
                if item.offset % 2 == 0 {
                    let newPokemons = PokemonCellModel(firstPokemon: item.element, secondPokemon: result[safe: item.offset + 1])
                    pokemonsCells.append(newPokemons)
                }
            }
            self.isLoadingPage = false
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
        
    func loadMorePokemonIfNeeded(current pokemonCell: PokemonCellModel) {
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
            .pokemons(from: url)
            .replaceError(with: PokemonResult())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemonResult, on: self)
    }
}
