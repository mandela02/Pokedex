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
        }
    }
    @Published var description: String = ""
    
    private var cancellables = Set<AnyCancellable>()

    private func initPokemonSpecies(from url: String) {
         Session.share.species(from: url)
            .replaceError(with: Species())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.species, on: self)
            .store(in: &cancellables)
    }
    
    func createText() -> String {
        return StringHelper.getEnglishTexts(from: species.flavorTextEntries)
    }
}
