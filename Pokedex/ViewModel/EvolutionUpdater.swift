//
//  EvolutionUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation
import Combine

struct EvoLink: Identifiable {
    var id = UUID().uuidString
    var from: NamedAPIResource
    var to: NamedAPIResource
    var detail: [EvolutionDetail]
    var triggers: String
}

class EvolutionUpdater: ObservableObject {
    init(of species: Species) {
        self.species = species
    }
    
    var species: Species? {
        didSet {
            if let megas = species?.megas {
                megaEvolutionLinks = megas.map({EvoLink(from: species?.pokemon ?? NamedAPIResource(), to: $0, detail: [], triggers: "Mega")})
            }
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
                    links.append(EvoLink(from: fromPokemon, to: toPokemon, detail: detail, triggers: getTriggerString(from: detail)))
                }
            }
            evolutionLinks = links
        }
    }

    @Published var evolutionLinks: [EvoLink] = []
    @Published var megaEvolutionLinks: [EvoLink] = []

    private var cancellables = Set<AnyCancellable>()
    
    private func initEvolution(of url: String) {
        Session.share.evolution(from: url)
            .replaceError(with: Evolution())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.evolution, on: self)
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
}
