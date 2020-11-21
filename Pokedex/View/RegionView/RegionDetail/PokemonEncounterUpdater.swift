//
//  LocationPokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import Foundation
import Combine

class PokemonEncounterUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var error: ApiError = .non
    var pokemon: Pokemon?
    var pokemonEncounter: PokemonEncounters? {
        didSet {
            guard let pokemonEncounter = pokemonEncounter else { return }
            combineResult(of: pokemonEncounter)
        }
    }
    
    private func getPokemon(from url: String) -> AnyPublisher<Pokemon, Error> {
        if url.isEmpty {
            pokemon = nil
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
        return Session.share.pokemon(from: url)
            .eraseToAnyPublisher()
    }
    
    private func getEncounterMethod(from versionDetail: PokemonVesionDetail) -> AnyPublisher<[EncounterMethod], Error> {
        if versionDetail.detail.isEmpty {
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        
        let methods = versionDetail.detail.map({$0.method.url}).uniques
        
        return Publishers.MergeMany(methods.map({ Session.share.encounterMethod(from: $0)}))
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func combineResult(of encounter: PokemonEncounters) {
        if encounter.pokemon.url.isEmpty,
           encounter.detail.isEmpty {
            return
        }
        
        guard let encounterDetail = encounter.detail.first else { return }
        
        Publishers.CombineLatest(getPokemon(from: encounter.pokemon.url),
                                 getEncounterMethod(from: encounterDetail))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                }
            } receiveValue: { pokemon, methods in
                
            }.store(in: &cancellables)

    }
}
