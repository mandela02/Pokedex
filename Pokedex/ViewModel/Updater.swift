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
    
    static func getCells(from result: [NamedAPIResource]) -> [PokemonCellModel] {
        var cells: [PokemonCellModel] = []
        
        result.enumerated().forEach { item in
            if item.offset % 2 == 0 {
                let newPokemons = PokemonCellModel(firstPokemon: item.element, secondPokemon: result[safe: item.offset + 1])
                cells.append(newPokemons)
            }
        }
        
        return cells
    }
}

class Updater: ObservableObject {
    @Published var allPokemons: [Pokemon] = []

    private var canLoadMore = true
    @Published var isLoadingPage = false
    @Published var isFinal = false
    private var cancellables = Set<AnyCancellable>()

    var url: String = "" {
        didSet {
            loadPokemonData()
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
            loadPokemonDetailData()
            self.isLoadingPage = false
        }
    }
            
    func loadMorePokemonIfNeeded(current pokemon: Pokemon) {
        let thresholdIndex = allPokemons.index(allPokemons.endIndex, offsetBy: -5)
        if allPokemons.firstIndex(where: { $0.pokeId == pokemon.pokeId}) == thresholdIndex {
            loadPokemonData()
        }
    }
    
    private func loadPokemonData() {
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
    
    private func loadPokemonDetailData() {
        Publishers.MergeMany(pokemonResult.results.map({Session.share.pokemon(from: $0.url)}))
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] pokemons in
                guard let self = self else { return }
                self.allPokemons = self.allPokemons + pokemons.sorted(by: {$0.pokeId < $1.pokeId})
            }
            .store(in: &cancellables)
    }
}
