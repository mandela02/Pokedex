//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

class MainPokedexUpdater: ObservableObject {
    @Published var isLoadingPage = false
    @Published var isFinal = false
    @Published var settings = UserSettings()
    @Published var error: ApiError = .non
    @Published var isTopView = false

    private var cancellables = Set<AnyCancellable>()
    private var canLoadMore = true
    
    var url: String = "" {
        didSet {
            loadPokemonResource()
        }
    }

    @Published var pokemonResult: PokemonResult = PokemonResult() {
        didSet {
            if pokemonResult.count != settings.speciesCount {
                settings.speciesCount = pokemonResult.count
            }
            if let nextUrl = pokemonResult.next {
                url = nextUrl
            } else {
                canLoadMore = false
                isFinal = true
            }
            loadPokemonsData()
        }
    }
    
    @Published var pokemons: [Pokemon] = [] {
        didSet {
            self.isLoadingPage = false
            isFinal = pokemonResult.next == nil
        }
    }
            
    func loadMorePokemonIfNeeded(current pokemon: Pokemon) {
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
        if pokemons.firstIndex(where: { $0.pokeId == pokemon.pokeId}) == thresholdIndex {
            loadPokemonResource()
        }
    }
    
    private func loadPokemonResource() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        
        isLoadingPage = true
        
        Session
            .share
            .pokemons(from: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished: self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                    self.isLoadingPage = false
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.pokemonResult = result
            }).store(in: &cancellables)
    }
    
    private func loadPokemonsData() {
        let pokemonUrls = pokemonResult.results.map({UrlType.getPokemonUrl(of: StringHelper.getPokemonId(from: $0.url))})
        Publishers.MergeMany(pokemonUrls.map({Session.share.pokemon(from: $0)}))
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished: self.error = .non
                case .failure(let message):
                    self.isLoadingPage = false
                    self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] pokemons in
                guard let self = self else { return }
                self.pokemons = self.pokemons + pokemons.sorted(by: {$0.pokeId < $1.pokeId})
            }).store(in: &cancellables)
    }
}
