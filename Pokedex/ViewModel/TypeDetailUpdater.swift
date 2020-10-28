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

    @Published var type: PokeType = PokeType() {
        didSet {
            merge()
        }
    }


    @Published var pokemons: [Pokemon] = [] {
        didSet {
            isLoading = false
        }
    }
    
    @Published var damage: MoveDamageClass = MoveDamageClass()

    @Published var name: String = ""

    @Published var url: String = "" {
        didSet {
            getTypeDetail(from: url)
        }
    }
    
    @Published var hasNoPokemon: Bool = false
    @Published var error: ApiError = .non

    private var cancellables = Set<AnyCancellable>()
    
    private func getTypeDetail(from url: String) {
        Session.share.type(from: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.type = result
            }).store(in: &cancellables)
    }
    
    private func getDamageDetail() -> AnyPublisher<MoveDamageClass, Never> {
        Session.share.moveDamageClass(from: type.moveDamageClass?.url ?? "https://pokeapi.co/api/v2/move-damage-class/0/")
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .failure(let error): self.error = .internet(message: error.localizedDescription)
                case .finished: self.error = .non
                }
            })
            .replaceEmpty(with: MoveDamageClass())
            .replaceError(with: MoveDamageClass())
            .eraseToAnyPublisher()
    }
        
    private func loadPokemonDetailData() -> AnyPublisher<[Pokemon], Never> {
        return  Publishers.MergeMany(type.pokemon.map({Session.share.pokemon(from: $0.pokemon.url)}))
            .collect()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .failure(let error): self.error = .internet(message: error.localizedDescription)
                case .finished: self.error = .non
                }
            })
            .replaceEmpty(with: [])
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    private func merge() {
        if type.pokemon.isEmpty {
            hasNoPokemon = true
        }

        if type.moveDamageClass?.url == nil && type.pokemon.isEmpty {
            isLoading = false
            return
        }
        
        Publishers.Zip(loadPokemonDetailData(), getDamageDetail())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (pokemons, damage) in
                self?.damage = damage
                self?.pokemons = pokemons.filter({$0.isDefault})
            }
            .store(in: &cancellables)
    }
}
