//
//  EvolutionUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation
import Combine

enum EvolutionTrigger {
    case level
    case trade
    case item
    case shed
}

struct EvoLink: Identifiable {
    var id = UUID().uuidString
    var from: NamedAPIResource
    var fromSpecies: Species?
    var to: NamedAPIResource
    var toSpecies: Species?
    var detail: [EvolutionDetail]
    var triggers: String?
}

struct MegaEvoLink: Identifiable {
    var id = UUID().uuidString
    var fromSpecies: Species?
    var toPokemon: Pokemon?
    var triggers: String? = "Mega"
}

class EvolutionUpdater: ObservableObject {
    init(of species: Species) {
        self.species = species
    }
    
    var species: Species? {
        didSet {
            if let megas = species?.megas {
                getMegaPokemons(from: megas)
            }
        }
    }
        
    @Published var megaPokemons: [Pokemon] = [] {
        didSet {
            megaEvolutionLinks = megaPokemons.map({
                MegaEvoLink(fromSpecies: species, toPokemon: $0)
            })
        }
    }

    
    @Published var evolution: Evolution = Evolution() {
        didSet {
            evolutionChains = evolution.allChains
        }
    }
    
    @Published var evolutionChains: [EvolutionChain] = [] {
        didSet {
            var links: [EvoLink] = []
            for (index, element) in evolutionChains.enumerated() {
                let fromPokemon = element.species
                if let nextElement = evolutionChains[safe: index + 1] {
                    let toPokemon = nextElement.species
                    let detail = nextElement.evolutionDetails
                    links.append(EvoLink(from: fromPokemon, to: toPokemon, detail: detail))
                }
            }
            psuedoEvolutionLink = links
        }
    }
    
    @Published var psuedoEvolutionLink: [EvoLink] = [] {
        didSet {
            let speciesUrls = evolutionChains.map({$0.species})
            getSpecies(from: speciesUrls)
        }
    }
    
    @Published var allSpeciesInChain: [Species] = [] {
        didSet {
            evolutionLinks = psuedoEvolutionLink.map({ [weak self] in EvoLink(from: $0.from,
                                                                              fromSpecies: self?.getSpecies(from: $0.from.name),
                                                                              to: $0.to,
                                                                              toSpecies: self?.getSpecies(from: $0.to.name),
                                                                              detail: $0.detail,
                                                                              triggers: self?.getTriggerString(from: $0.detail))})
        }
    }
            
    @Published var evolutionLinks: [EvoLink] = []
    @Published var evolutionTrigger: EvolutionTriggers = EvolutionTriggers()
    @Published var megaEvolutionLinks: [MegaEvoLink] = []

    private var cancellables = Set<AnyCancellable>()
    
    private func initEvolution(of url: String) {
        Session.share.evolution(from: url)
            .replaceError(with: Evolution())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.evolution, on: self)
            .store(in: &cancellables)
    }
    
    private func getSpecies(from urls: [NamedAPIResource]) {
        if urls.isEmpty {
            allSpeciesInChain = []
            return
        }
        Publishers
            .Sequence(sequence: urls.map({Session.share.species(from: $0.url)}))
            .flatMap{ $0 }
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.allSpeciesInChain, on: self)
            .store(in: &cancellables)
    }

    private func getSpecies(from name: String) -> Species {
        return allSpeciesInChain.filter({$0.name == name}).first ?? Species()
    }
    
    private func getMegaPokemons(from urls: [NamedAPIResource]) {
        if urls.isEmpty {
            allSpeciesInChain = []
            return
        }
        Publishers
            .Sequence(sequence: urls.map({Session.share.pokemon(from: $0.url)}))
            .flatMap{ $0 }
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.megaPokemons, on: self)
            .store(in: &cancellables)
    }
    
    private func getTriggerString(from details: [EvolutionDetail]) -> String {
        guard let mainTrigger = details.first else {
            return ""
        }
        
        switch mainTrigger.evolutionTrigger {
        case .level:
            if let level = mainTrigger.minLevel {
                return "Level \(level)"
            }
            return "Unknow"
        case .trade:
            return "Trade"
        case .item:
            if let item = mainTrigger.heldItem?.name {
                return item
            }
            return "Unknow"
        case .shed:
            return "Shed"
        }
    }
    
    func getPokemonLink(from link: EvoLink) -> String {
        if link.fromSpecies?.name == species?.name {
            return link.toSpecies?.pokemon.url ?? ""
        } else {
            return link.fromSpecies?.pokemon.url ?? ""
        }
    }
}
