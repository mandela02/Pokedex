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
    var from: Pokemon
    var to: Pokemon
}

class EvolutionUpdater {
    @Published var evolution: Evolution = Evolution() {
        didSet {
            evolutionChains = evolution.allChains
        }
    }
    @Published var evolutionChains: [EvolutionChain] = []
    
    private var cancellable: AnyCancellable?
    private var species: Species?

    deinit {
        cancellable?.cancel()
    }
    
    init(of species: Species) {
        self.species = species
        initEvolutionChain(of: species.evolutionChain.url)
    }
    
    private func initEvolutionChain(of url: String) {
        self.cancellable = Session.share.evolution(from: url)?
            .replaceError(with: Evolution())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.evolution, on: self)
    }
}
