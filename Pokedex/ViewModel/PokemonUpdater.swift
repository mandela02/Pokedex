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
    init(url: String) {
        self.pokemonUrl = url
    }
   
    deinit {
        cancellable?.cancel()
    }
        
    @Published var pokemonUrl: String? {
        didSet {
            initPokemon()
        }
    }

    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            generateId(from: pokemon)
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
    @Published var currentId: Int = 0
    @Published var nextId: Int = 0
    @Published var previousId: Int = 0

    private func initPokemon() {
        guard let url = pokemonUrl else { return }
        self.cancellable = Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] out in
                self?.isFinishLoading = true
            })
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
    }
    
    private func generateId(from pokemon: Pokemon) {
        currentId = pokemon.pokeId
        nextId = currentId + 1
        previousId = currentId - 1
    }
    
    func moveForward() {
        pokemonUrl = UrlType.getPokemonUrl(of: nextId)
    }
    
    func moveBack() {
        pokemonUrl = UrlType.getPokemonUrl(of: previousId)
    }
}
