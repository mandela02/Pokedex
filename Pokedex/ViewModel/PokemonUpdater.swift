//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Combine
import SwiftUI

class PokemonUpdater: ObservableObject {
    init(url: String) {
        self.pokemonUrl = url
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    var imageCache = ImageCache.getImageCache()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pokemonUrl: String? {
        didSet {
            initPokemon()
        }
    }
    
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            updateCurrentId(of: pokemon)
            speciesUrl = pokemon.species.url
        }
    }
    
    var speciesUrl: String = "" {
        didSet {
            initPokemonSpecies(from: speciesUrl)
        }
    }

    @Published var species: Species = Species()

    @Published var isSelected = false
    
    @Published var preLoadImages: [UIImage?] = []
    @Published var images: [String] = []
    @Published var ids: [Int] = [] {
        didSet {
            images = ids.map({UrlType.getImageUrlString(of: $0)})
        }
    }
    
    @Published var currentId: Int = 0 {
        didSet {
            if currentId > 0 {
                ids = [currentId - 1, currentId, currentId + 1]
            }
        }
    }
    
    private func initPokemon() {
        guard let url = pokemonUrl, !url.isEmpty else { return }
        Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
            .store(in: &cancellables)
    }
    
    private func initPokemonSpecies(from url: String) {
         Session.share.species(from: url)
            .replaceError(with: Species())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.species, on: self)
            .store(in: &cancellables)
    }
    
    func update(onSuccess: () -> ()) {
        let nextUrl = UrlType.getPokemonUrl(of: currentId)
        if pokemonUrl != nextUrl {
            pokemonUrl = nextUrl
            onSuccess()
        }
    }
    
    private func updateCurrentId(of pokemon: Pokemon) {
        if currentId != pokemon.pokeId {
            currentId = pokemon.pokeId
        }
    }
}
