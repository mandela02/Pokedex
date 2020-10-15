//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Foundation
import Combine
import AVFoundation

class PokemonUpdater: ObservableObject {
    @Published var pokemon: Pokemon = Pokemon()
    
    @Published var pokemonUrl: String? {
        didSet {
            initPokemon()
        }
    }
        
    @Published var isFinishLoading = false
    @Published var isSelected = false {
        didSet {
            if isSelected {
                //print(pokemon)
            }
        }
    }

    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    init(url: String) {
        self.pokemonUrl = url
    }
    
    private func initPokemon() {
        guard let url = pokemonUrl else { return }
        self.cancellable = Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isFinishLoading = true
            })
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
    }
}
