//
//  Updater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine

struct PokedexCellModel: Identifiable, Equatable {
    var id: String {
        return pokemonUrl
    }
    
    var pokemonUrl: String = ""
    var speciesUrl: String = ""
    
    var isEmpty: Bool {
        pokemonUrl.isEmpty && speciesUrl.isEmpty
    }
}

class MainPokedexUpdater: ObservableObject {
    @Published var isLoadingPage = false
    @Published var isFinal = false
    @Published var settings = UserSettings()
    @Published var error: ApiError = .non
    
    private var cancellable: Cancellable?
    private var canLoadMore = true
    var isTopView = false
    
    var url: String = "" {
        didSet {
            loadPokemonResource()
        }
    }

    private var pokemonResult: PokemonResult = PokemonResult() {
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
            pokedexCellModels = pokedexCellModels +
                pokemonResult
                .results
                .map({PokedexCellModel(pokemonUrl: UrlType.getPokemonUrl(of: StringHelper.getPokemonId(from: $0.url)),
                                       speciesUrl: $0.url)})
        }
    }
    
    var pokedexCellModels: [PokedexCellModel] = [] {
        didSet {
            self.isLoadingPage = false
        }
    }
                
    func loadMorePokemonIfNeeded(current pokedexCellModel: PokedexCellModel) {
        guard isTopView else { return }
        let thresholdIndex = pokedexCellModels.index(pokedexCellModels.endIndex, offsetBy: -5)
        if pokedexCellModels.firstIndex(where: { $0 == pokedexCellModel}) == thresholdIndex {
            loadPokemonResource()
        }
    }
    
    private func loadPokemonResource() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        
        isLoadingPage = true
        
        cancellable =  Session
            .share
            .pokemons(from: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let message):
                    self.error = .internet(message: message.localizedDescription)
                    self.isLoadingPage = false
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.pokemonResult = result
            })
    }
}
