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
    var fromSpecies: Species?
    var to: NamedAPIResource
    var toSpecies: Species?
    var detail: [EvolutionDetail]
}

class EvolutionUpdater: ObservableObject {
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
    
    @Published var speciesChain: [Species] = [] {
        didSet {
            evolutionLinks = psuedoEvolutionLink.map({ [weak self] in EvoLink(from: $0.from,
                                                                         fromSpecies: self?.getSpecies(from: $0.from.name),
                                                                         to: $0.to,
                                                                         toSpecies: self?.getSpecies(from: $0.to.name),
                                                                         detail: $0.detail)})
        }
    }
    
    @Published var evolutionLinks: [EvoLink] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var species: Species?
    private var isFirstTimeLoad = true
    
    init(of species: Species) {
        self.species = species
        initEvolution(of: species.evolutionChain.url)
    }
    
    private func initEvolution(of url: String) {
        Session.share.evolution(from: url)
            .replaceError(with: Evolution())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.evolution, on: self)
            .store(in: &cancellables)
    }
    
    private func getSpecies(from urls: [NamedAPIResource]) {
        Publishers
            .Sequence(sequence: urls.map({Session.share.species(from: $0.url)}))
            .flatMap{ $0 }
            .collect()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.speciesChain, on: self)
            .store(in: &cancellables)
    }
    
    func getSpecies(from name: String) -> Species {
        return speciesChain.filter({$0.name == name}).first ?? Species()
    }
}
