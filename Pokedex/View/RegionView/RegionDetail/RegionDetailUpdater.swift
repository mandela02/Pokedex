//
//  RegionDetailUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import Foundation
import Combine
class RegionDetailUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    var url: String? {
        didSet {
            getRegion(from: url)
        }
    }
    
    @Published var region: Region? {
        didSet {
            guard let region = region else { return }
            locations = [selectedLocation] + region.locations.map({$0.name.capitalizingFirstLetter().eliminateDash})
            getPokedex(from: region)
        }
    }
    
    @Published var locations: [String] = []
    @Published var selectedLocation: String = "default" {
        didSet {
            if firstTimeLoading && selectedLocation != "default" {
                legionName = selectedLocation
                firstTimeLoading = false
            }
            
            if selectedLocation == legionName {
                getPokedex(from: region)
            } else {
                pokedexNames.removeAll()
            }
        }
    }
    private var legionName = ""
    private var firstTimeLoading = true
    @Published var pokedexNames: [String] = [] {
        didSet {
            isHavingMultiDex = pokedexNames.count > 1
        }
    }
    @Published var isHavingMultiDex = false
    @Published var selectedPokedex: String = "" {
        didSet {
            guard let region = region else { return }
            let pokedexs = region.pokedexes
            if pokedexs.isEmpty { return }
            let currentDex = selectedPokedex.lowercased()
            if let pokedexUrl = pokedexs.first(where: {$0.name.eliminateDash == currentDex})?.url {
                getPokemons(from: pokedexUrl)
            }
        }
    }
    @Published var pokedexCellModels: [PokedexCellModel] = []

    func getRegion(from url: String?) {
        guard let url = url else { return }
        Session.share.region(from: url)
            .replaceError(with: Region())
            .receive(on: DispatchQueue.main)
            .sink { region in
                self.region = region
            }.store(in: &cancellables)
    }
    
    func getPokedex(from region: Region?) {
        guard let region = region else { return }
        let dexs = region.pokedexes
        if dexs.isEmpty { return }
        pokedexNames = dexs.map({$0.name.eliminateDash.capitalizingFirstLetter()})
        selectedPokedex = pokedexNames.first ?? ""
    }
    
    func getPokemons(from url: String) {
        if url.isEmpty { return }
        Session.share.pokedex(from: url)
            .replaceError(with: Pokedex())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokedex in
                guard let self = self else { return }
                self.pokedexCellModels = self.getPokemonCellModels(form: pokedex)
            }.store(in: &cancellables)
    }
    
    private func getPokemonCellModels(form pokedex: Pokedex) -> [PokedexCellModel] {
        return pokedex.pokemons
            .map({PokedexCellModel(pokemonUrl: UrlType.getPokemonUrl(of: StringHelper.getPokemonId(from: $0.species.url)),
                                   speciesUrl: $0.species.url)})
    }
}
