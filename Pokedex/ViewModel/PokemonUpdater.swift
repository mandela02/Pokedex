//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Foundation
import Combine

class PokemonUpdater: ObservableObject {
    @Published var pokemon: Pokemon = Pokemon()
    var pokemonUrl: String?
    private var cancellable: AnyCancellable?

    deinit {
        cancellable?.cancel()
    }
    
    init(url: String) {
        self.cancellable = Session
            .share
            .pokemon(from: url)?
            .replaceError(with: Pokemon())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)

    }
}
