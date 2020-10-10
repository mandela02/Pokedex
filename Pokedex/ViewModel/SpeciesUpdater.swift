//
//  SpecieUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation
import Combine

class SpeciesUpdater: ObservableObject {
    @Published var species: Species = Species() {
        didSet {
            description = createText()
            let more = EvolutionUpdater(of: species)
        }
    }
    @Published var description: String = ""

    private var cancellable: AnyCancellable?

    deinit {
        cancellable?.cancel()
    }
    
    init(url: String) {
        initPokemonSpecies(from: url)
    }
        
    private func initPokemonSpecies(from url: String) {
        self.cancellable = Session.share.species(from: url)?
            .replaceError(with: Species())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.species, on: self)
    }
    
    func createText() -> String {
        return StringHelper.createEnglishText(from: species.flavorTextEntries)
    }
}
