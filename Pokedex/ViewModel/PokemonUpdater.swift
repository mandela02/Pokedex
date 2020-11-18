//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Combine
import SwiftUI

struct PokemonModel {
    var pokemon: Pokemon = Pokemon()
    var species: Species = Species()
}

class PokemonUpdater: ObservableObject {
    init() {
        initObservers()
    }
    
    deinit {
        cancellables.removeAll()
        pokedexCellModel.send(completion: .finished)
    }
    
    private var cancellables = Set<AnyCancellable>()

    @Published var error: ApiError = .non
    var isTopView = true
    var retry = false {
        didSet {
            if retry && isTopView {
                //initPokemon()
            }
        }
    }
        
    private var isFirstTimeLoadViewModel = true
    
    @Published var settings = UserSettings()
    @Published var currentScrollIndex = 0
    @Published var isLoadingNewData = false
    
    var pokedexCellModel = CurrentValueSubject<PokedexCellModel, Never>(PokedexCellModel())
    
    @Published var pokemonModel: PokemonModel = PokemonModel() {
        didSet {
            if pokemonModel.pokemon.pokeId != 0 {
                updateCurrentId(of: pokemonModel.pokemon)
            }
            
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
    
    func initPokedexCellModel(model: PokedexCellModel) {
        pokedexCellModel.send(model)
    }
    
    private func initObservers() {
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
        
        pokedexCellModel.dropFirst().map({ [weak self] pokedexCellModel -> AnyPublisher<(Pokemon, Species), Never>? in
            guard let self = self, !pokedexCellModel.isEmpty else { return nil }
            return self.zip(pokemonUrl: pokedexCellModel.pokemonUrl, speciesUrl: pokedexCellModel.speciesUrl)
        })
        .compactMap({ $0 })
        .flatMap({ $0 })
        .receive(on: DispatchQueue.main)
        .sink { [weak self] pokemon, species in
            guard let self = self else { return }
            self.pokemonModel = PokemonModel(pokemon: pokemon, species: species)
        }.store(in: &cancellables)
    }
}

extension PokemonUpdater {
    private func getPokemon(from url: String) -> AnyPublisher<Pokemon, Never> {
        guard !url.isEmpty else { return PassthroughSubject<Pokemon, Never>().eraseToAnyPublisher() }
        return Session.share.pokemon(from: url)
            .replaceError(with: Pokemon())
            .eraseToAnyPublisher()
    }
    
    private func getSpecies(from url: String) -> AnyPublisher<Species, Never> {
        guard !url.isEmpty else { return PassthroughSubject<Species, Never>().eraseToAnyPublisher() }
        return Session.share.species(from: url)
            .replaceError(with: Species())
            .eraseToAnyPublisher()
    }
    
    private func zip(pokemonUrl: String, speciesUrl: String) -> AnyPublisher<(Pokemon, Species), Never> {
        Publishers.Zip(getPokemon(from: pokemonUrl),
                       getSpecies(from: speciesUrl))
            .eraseToAnyPublisher()
    }
}

extension PokemonUpdater {
    func update() {
        let nextUpdate = PokedexCellModel(pokemonUrl: UrlType.getPokemonUrl(of: currentId),
                                          speciesUrl: UrlType.getSpeciesUrl(of: currentId))
        if pokedexCellModel.value != nextUpdate {
            pokedexCellModel.send(nextUpdate)
        } else {
            isLoadingNewData = false
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
}
