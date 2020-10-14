//
//  TypeUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import Foundation
import Combine

struct TypeCell: Identifiable {
    var id: Int {
        type.id
    }
    var type: PokeType
    var cells: [PokemonCell]
}

class TypeUpdater: ObservableObject {
    @Published var allTypes: [PokemonType] = PokemonType.allCases
    
    init() {
        isLoading = true
        getAllType()
    }
    @Published private var url = UrlType.type.urlString
    
    private var results: PokemonResult = PokemonResult() {
        didSet {
            typeUrls = results.results
        }
    }
    
    @Published private var typeUrls: [NamedAPIResource] = [] {
        didSet {
            getTypes(from: typeUrls)
        }
    }
    @Published private var types: [PokeType] = [] {
        didSet {
            types.forEach { type in
                let pokemonUrls = type.pokemon.map({$0.pokemon})
                typeCells.append(TypeCell(type: type,
                                          cells: getCells(from: pokemonUrls)))
            }
        }
    }
    
    @Published var typeCells: [TypeCell] = [] {
        didSet {
            isLoading = false
        }
    }
    
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    private func getAllType() {
         Session
            .share
            .pokemons(from: url)
            .replaceError(with: PokemonResult())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.results, on: self)
            .store(in: &cancellables)
    }
    
    private func getTypes(from urls: [NamedAPIResource]) {
        if urls.isEmpty {
            types = []
            return
        }
        Publishers
            .Sequence(sequence: urls.map({Session.share.type(from: $0.url)}))
            .flatMap{ $0 }
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.types, on: self)
            .store(in: &cancellables)
    }
    
    func getCells(from result: [NamedAPIResource]) -> [PokemonCell] {
        var cells: [PokemonCell] = []
        
        result.enumerated().forEach { item in
            if item.offset % 2 == 0 {
                let newPokemons = PokemonCell(firstPokemon: item.element, secondPokemon: result[safe: item.offset + 1])
                cells.append(newPokemons)
            }
        }
        
        return cells
    }
}
