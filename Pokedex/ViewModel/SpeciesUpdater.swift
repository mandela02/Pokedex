//
//  SpecieUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation
import Combine

class SpeciesUpdater: ObservableObject {
    init(url: String) {
        self.speciesUrl = url
    }

    var speciesUrl: String = "" {
        didSet {
            initPokemonSpecies(from: speciesUrl)
        }
    }


    @Published var species: Species = Species() {
        didSet {
            description = createText()
            initEvolution(of: species.evolutionChain.url)
        }
    }

    @Published var description: String = ""
    @Published var evolution: Evolution = Evolution()

    private var cancellables = Set<AnyCancellable>()

    private func initPokemonSpecies(from url: String) {
         Session.share.species(from: url)
            .replaceError(with: Species())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.species, on: self)
            .store(in: &cancellables)
    }
    
    func createText() -> String {
        return StringHelper.getEnglishTexts(from: species.flavorTextEntries)
    }
    
    
    private func initEvolution(of url: String) {
        Session.share.evolution(from: url)
            .replaceError(with: Evolution())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.evolution, on: self)
            .store(in: &cancellables)
    }
}
