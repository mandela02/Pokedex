//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Combine
import SwiftUI

class PokemonUpdater: ObservableObject {
    init() {
        wait()
        print("init \(pokemonUrl)")
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private var isFirstTimeLoadViewModel = true
    private var cancellables = Set<AnyCancellable>()
    
    @Published var settings = UserSettings()
    @Published var currentScrollIndex = 0
    @Published var isScrollingEnable = true
    @Published var isLoadingNewData = false

    var pokemonUrl: String? {
        didSet {
            if pokemonUrl != "" {
                initPokemon()
            }
        }
    }
    
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            updateCurrentId(of: pokemon)
            speciesUrl = pokemon.species.url
        }
    }

    private var speciesUrl: String = "" {
        didSet {
            initPokemonSpecies(from: speciesUrl)
        }
    }
    
    @Published var species: Species = Species() {
        didSet {
            isScrollingEnable = true
            self.isLoadingNewData = false
        }
    }
    
    private var currentId: Int = 0 {
        didSet {
            if isFirstTimeLoadViewModel {
                generateIds()
                isFirstTimeLoadViewModel = false
            }
        }
    }

    private var ids: [Int] = [] {
        didSet {
            images = ids.map({$0 == 0 ? "" : UrlType.getImageUrlString(of: $0)})
        }
    }
    
    @Published var images: [String] = []
    
    @Published var error: ApiError = .non
    @Published var isTopView = true
    @Published var retry = false {
        didSet {
            if retry && isTopView {
                initPokemon()
            }
        }
    }

    private func initPokemon() {
        guard let url = pokemonUrl, !url.isEmpty else {
            return
        }
        Session
            .share
            .pokemon(from: url)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.pokemon = result
            })
            .store(in: &cancellables)
    }
    
    private func initPokemonSpecies(from url: String) {
        Session.share.species(from: url)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.species = result
            })
            .store(in: &cancellables)
    }
    
    func update() {
        let nextUrl = UrlType.getPokemonUrl(of: currentId)
        if pokemonUrl != nextUrl {
            pokemonUrl = nextUrl
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
        //isScrollingEnable = false
        isLoadingNewData = true
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
            } else {
                currentScrollIndex += 1
                isLoadingNewData = false
            }
        case .right:
            if currentId != settings.speciesCount {
                currentId += 1
                if currentId > 3 {
                    zeroArray[currentId - 3] = 0
                }
                zeroArray.append( currentId + 2 > settings.speciesCount ? 0 : currentId + 2)
                ids = zeroArray
            } else {
                currentScrollIndex -= 1
                isLoadingNewData = false
            }
        default:
            isLoadingNewData = false
            return
        }
    }
    
    private func wait() {
        // drop when url = ""
        // drop when first time load
        $images
            .dropFirst(2)
            .receive(on: RunLoop.main)
            .debounce(for: 0.75, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.update()
            })
            .store(in: &cancellables)
    }
}
