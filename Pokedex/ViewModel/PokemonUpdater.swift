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
    
    private var isFirstTimeLoadViewModel = true
    private var cancellables = Set<AnyCancellable>()
    
    @Published var settings = UserSettings()
    @Published var currentScrollIndex = 0
    @Published var isScrollingEnable = true
    
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
    
    @Published var speciesUrl: String = "" {
        didSet {
            initPokemonSpecies(from: speciesUrl)
        }
    }
    
    @Published var species: Species = Species() {
        didSet {
            isScrollingEnable = true
        }
    }
    
    @Published var images: [String] = []
    
    @Published var ids: [Int] = [] {
        didSet {
            images = ids.map({UrlType.getImageUrlString(of: $0)})
        }
    }
    
    @Published var currentId: Int = 0 {
        didSet {
            if isFirstTimeLoadViewModel {
                generateIds()
                isFirstTimeLoadViewModel = false
            }
        }
    }
    
    private func initPokemon() {
        guard let url = pokemonUrl, !url.isEmpty else { return }
        Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
            .store(in: &cancellables)
    }
    
    private func initPokemonSpecies(from url: String) {
        Session.share.species(from: url)
            .replaceError(with: Species())
            .receive(on: RunLoop.main)
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
    
    private func generateIds() {
        var zeroArray = Array(repeating: 0, count: currentId + 3)
        currentScrollIndex = currentId
        if currentId > 1 {
            zeroArray[currentId - 1] = currentId - 1
        }
        if currentId > 2 {
            zeroArray[currentId - 2] = currentId - 2
        }
        
        zeroArray[currentId] = currentId
        zeroArray[currentId + 1] = currentId + 1 > settings.speciesCount ? 0 : currentId + 1
        zeroArray[currentId + 2] = currentId + 2 > settings.speciesCount ? 0 : currentId + 2
        ids = zeroArray
    }
    
    func moveTo(direction: Direction) {
        isScrollingEnable = false
        var zeroArray = ids
        switch direction {
        case .left:
            if currentId != 1 {
                currentId -= 1
                if currentId > 1 {
                    zeroArray[currentId - 1] = currentId - 1
                }
                if currentId > 2 {
                    zeroArray[currentId - 2] = currentId - 2
                }
                zeroArray.removeLast()
                ids = zeroArray
                update {}
            } else {
                currentScrollIndex += 1
            }
        case .right:
            if currentId != settings.speciesCount {
                currentId += 1
                if currentId > 3 {
                    zeroArray[currentId - 3] = 0
                }
                zeroArray.append( currentId + 2 > settings.speciesCount ? 0 : currentId + 2)
                ids = zeroArray
                update {}
            } else {
                currentScrollIndex -= 1
            }
        default:
            return
        }
    }
    
    private func wait() {
        $images
            .receive(on: RunLoop.main)
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                self?.update {}
            })
            .store(in: &cancellables)
    }
}
