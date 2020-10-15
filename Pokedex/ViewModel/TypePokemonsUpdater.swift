//
//  TypePokemonsUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/14/20.
//

import Foundation
import Combine

class TypePokemonsUpdater: ObservableObject {
    init(type: PokemonType? = nil) {
        self.pokemonType = type
    }

    @Published var pokemonType: PokemonType? {
        didSet {
            name = pokemonType?.rawValue ?? ""
            url = pokemonType?.url ?? ""
        }
    }

    @Published var name: String = ""

    @Published var url: String = "" {
        didSet {
            getTypeDetail(from: url)
        }
    }
    
    @Published var type: PokeType = PokeType() {
        didSet {
            pokemons = getCells(from: type.pokemon.map({$0.pokemon}))
        }
    }

    @Published var pokemons: [PokemonCellModel] = []

    private var cancellables = Set<AnyCancellable>()
    
    private func getTypeDetail(from url: String) {
        Session.share.type(from: url)
        .replaceError(with: PokeType())
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        .assign(to: \.type, on: self)
        .store(in: &cancellables)
    }
    
    private func getCells(from result: [NamedAPIResource]) -> [PokemonCellModel] {
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
