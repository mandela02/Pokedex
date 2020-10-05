//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

class Updater: ObservableObject {
    @Published var pokemons: [PokemonUrl] = []
    private var cancellable: AnyCancellable?
    private var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            pokemons = pokemonResult.results.map({PokemonUrl(name: $0.name, url: $0.url)})
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    init() {
        self.cancellable = Session
            .share
            .pokemons(from: UrlType.pokemons.urlString)?
            .replaceError(with: PokemonResult())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemonResult, on: self)
    }
}
