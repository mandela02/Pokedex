//
//  LocationPokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import Foundation
import Combine
import SwiftUI

struct EncounterChanceCellModel: Identifiable {
    var id = UUID()
    
    var chance: Double
    var max: Int
    var min: Int
    var name: String
    var description: String
    var color: Color
    var conditions: [String]
}

struct PokemonEncounterModel {
    var pokemon: Pokemon
    var encounter: [EncounterChanceCellModel]
    var location: String
    var area: String
}

class PokemonEncounterUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var error: ApiError = .non
    
    var pokemonEncounter: AreaPokedexCellModel? {
        didSet {
            guard let pokemonEncounter = pokemonEncounter else { return }
            combineResult(of: pokemonEncounter.encounter)
        }
    }
    
    @Published var pokemonEncounterModel = PokemonEncounterModel(pokemon: Pokemon(), encounter: [], location: "", area: "")
    
    private func getPokemon(from url: String) -> AnyPublisher<Pokemon, Error> {
        if url.isEmpty {
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
    
    private func getCondition(from versionDetail: PokemonVesionDetail) -> AnyPublisher<[Condition], Error> {
        if versionDetail.detail.isEmpty {
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        
        let methods = versionDetail.detail.map({$0.condition}).flatMap({$0}).map({$0.url}).uniques
        
        return Publishers.MergeMany(methods.map({ Session.share.condition(from: $0)}))
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func combineResult(of encounter: PokemonEncounters) {
        guard let pokemonEncounter = pokemonEncounter  else {
            return
        }
        if encounter.pokemon.url.isEmpty,
           encounter.detail.isEmpty {
            return
        }
        
        guard let encounterDetail = encounter.detail.first else { return }
        
        Publishers.CombineLatest3(getPokemon(from: encounter.pokemon.url),
                                 getEncounterMethod(from: encounterDetail),
                                 getCondition(from: encounterDetail))
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
            } receiveValue: {[weak self] pokemon, methods, conditions in
                guard let self = self else { return }
                let maxChance = encounterDetail.maxChance
                let models = encounterDetail.detail.map { detail -> EncounterChanceCellModel in
                    let currentMethod = methods.first(where: {$0.name == detail.method.name})
                    let conditions = detail
                        .condition
                        .map({ condition in
                            return conditions.first(where: {$0.name == condition.name})
                        })
                        .compactMap({$0})
                        .map({StringHelper.getEnglishText(from: $0.names)})
                    return EncounterChanceCellModel(chance: Double(detail.chance) / Double(maxChance) * 100,
                                                    max: detail.maxLvl,
                                                    min: detail.minLvl,
                                                    name: detail.method.name.eliminateDash,
                                                    description: StringHelper.getEnglishText(from: currentMethod?.names ?? []),
                                                    color: pokemon.mainType.color.background, conditions: conditions)
                }
                
                self.pokemonEncounterModel = PokemonEncounterModel(pokemon: pokemon,
                                                                   encounter: models,
                                                                   location: pokemonEncounter.location,
                                                                   area: pokemonEncounter.area)
            }.store(in: &cancellables)
        
    }
}
