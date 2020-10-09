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
    @Published var isFinishLoading = false

    deinit {
        cancellable?.cancel()
    }
    
    init(url: String) {
        self.pokemonUrl = url
        initPokemon()
    }
    
    private func initPokemon() {
        guard let url = pokemonUrl else { return }
        self.cancellable = Session
            .share
            .pokemon(from: url)?
            .replaceError(with: Pokemon())
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isFinishLoading = true
            })
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
    }
}
