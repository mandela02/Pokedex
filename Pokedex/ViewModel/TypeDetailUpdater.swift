//
//  TypePokemonsUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/14/20.
//

import Foundation
import Combine

class TypeDetailUpdater: ObservableObject {
    init(type: PokemonType? = nil) {
        self.pokemonType = type
    }

    @Published var pokemonType: PokemonType? {
        didSet {
            name = pokemonType?.rawValue ?? ""
            url = pokemonType?.url ?? ""
        }
    }

    @Published var allPokemons: [Pokemon] = []
    
    @Published var name: String = ""

    @Published var url: String = "" {
        didSet {
            getTypeDetail(from: url)
        }
    }
    
    @Published var type: PokeType = PokeType() {
        didSet {
            getDamageDetail(from: type.moveDamageClass.url)
            loadPokemonDetailData()
        }
    }

    @Published var damage: MoveDamageClass = MoveDamageClass()

    private var cancellables = Set<AnyCancellable>()
    
    private func getTypeDetail(from url: String) {
        Session.share.type(from: url)
        .replaceError(with: PokeType())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        .assign(to: \.type, on: self)
        .store(in: &cancellables)
    }
    
    private func getDamageDetail(from url: String) {
        Session.share.moveDamageClass(from: url)
        .replaceError(with: MoveDamageClass())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        .assign(to: \.damage, on: self)
        .store(in: &cancellables)
    }
        
    private func loadPokemonDetailData() {
        Publishers.MergeMany(type.pokemon.map({Session.share.pokemon(from: $0.pokemon.url)}))
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.allPokemons, on: self)
            .store(in: &cancellables)
    }
}
