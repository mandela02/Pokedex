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

    @Published var isLoading = true
    
    @Published var pokemonType: PokemonType? {
        didSet {
            name = pokemonType?.rawValue ?? ""
            url = pokemonType?.url ?? ""
        }
    }

    @Published var pokemons: [Pokemon] = [] {
        didSet {
            isLoading = false
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
            merge()
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
    
    private func getDamageDetail() -> AnyPublisher<MoveDamageClass, Never> {
        Session.share.moveDamageClass(from: type.moveDamageClass?.url ?? "https://pokeapi.co/api/v2/move-damage-class/0/")
            .replaceEmpty(with: MoveDamageClass())
            .replaceError(with: MoveDamageClass())
            .eraseToAnyPublisher()
    }
        
    private func loadPokemonDetailData() -> AnyPublisher<[Pokemon], Never> {
        Publishers.MergeMany(type.pokemon.map({Session.share.pokemon(from: $0.pokemon.url)}))
            .collect()
            .replaceEmpty(with: [])
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    private func merge() {
        Publishers.Zip(loadPokemonDetailData(), getDamageDetail())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (pokemons, damage) in
                self?.damage = damage
                self?.pokemons = pokemons.filter({$0.isDefault})
            }
            .store(in: &cancellables)
    }
}
