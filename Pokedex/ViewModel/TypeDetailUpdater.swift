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
            pokedexCellModels = type.pokemon.map({PokedexCellModel(pokemonUrl: $0.pokemon.url,
                                                                   speciesUrl: UrlType.getSpeciesUrl(of: StringHelper.getPokemonId(from: $0.pokemon.url)))})
            getDamage()
        }
    }

    @Published var pokedexCellModels: [PokedexCellModel] = [] {
        didSet {
            isLoading = false
            hasNoPokemon = pokedexCellModels.isEmpty
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
    
    @Published var error: ApiError = .non {
        didSet {
            if error != .non {
                isLoading = false
            }
        }
    }
    
    var retry = false {
        didSet {
            if retry {
                getTypeDetail(from: url)
                retry = false
            }
        }
    }

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
        Session.share.moveDamageClass(from: type.moveDamageClass?.url ?? "")
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
    
    private func getDamage() {
        getDamageDetail()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] damage in
                guard let self = self else { return }
                self.damage = damage
            }
            .store(in: &cancellables)
    }
}
