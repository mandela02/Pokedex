//
//  RegionDetailUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import Foundation
import Combine

struct AreaPokedexCellModel: Identifiable {
    var id = UUID()
    var encounter: PokemonEncounters
    var url: String
}

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
            guard selectedLocation != oldValue else { return }

            if firstTimeLoading && selectedLocation != "default" {
                regionName = selectedLocation
                firstTimeLoading = false
            }
            
            if selectedLocation == regionName {
                areaNames.removeAll()
                selectedArea = ""
                getPokedex(from: region)
            } else {
                pokedexNames.removeAll()
                selectedPokedex = ""
                if let url = region?.locations.first(where: {$0.name.eliminateDash == selectedLocation.lowercased()})?.url {
                    getLocation(from: url)
                }
            }
            neededToShowDex = selectedLocation == regionName
        }
    }
    
    @Published var neededToShowDex = false
    
    private var regionName = ""
    
    private var firstTimeLoading = true
    
    @Published var pokedexNames: [String] = [] {
        didSet {
            isHavingMultiDex = pokedexNames.count > 0
        }
    }
    @Published var isHavingMultiDex = false
    @Published var selectedPokedex: String = "" {
        didSet {
            guard selectedPokedex != oldValue else { return }

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
    @Published var areaPokedexCellModels: [AreaPokedexCellModel] = []

    @Published var location: Location? {
        didSet {
            guard let location = location else { return }
            self.areaNames = location.areas.map({$0.name.eliminateDash.capitalizingFirstLetter()})
            self.selectedArea = self.areaNames.first ?? ""
        }
    }

    @Published var areaNames: [String] = [] {
        didSet {
            isHavingMultiArea = areaNames.count > 0
        }
    }
    @Published var isHavingMultiArea = false
    @Published var selectedArea = "" {
        didSet {
            guard selectedArea != oldValue else { return }
            
            guard let location = location else { return }
            let areas = location.areas
            if areas.isEmpty { return }
            let currentArea = selectedArea.lowercased()
            if let pokedexUrl = areas.first(where: {$0.name.eliminateDash == currentArea})?.url {
                getArea(from: pokedexUrl)
            }
        }
    }

    private func getRegion(from url: String?) {
        guard let url = url else { return }
        Session.share.region(from: url)
            .replaceError(with: Region())
            .receive(on: DispatchQueue.main)
            .sink { region in
                self.region = region
            }.store(in: &cancellables)
    }
    
    private func getPokedex(from region: Region?) {
        guard let region = region else { return }
        let dexs = region.pokedexes
        if dexs.isEmpty { return }
        pokedexNames = dexs.map({$0.name.eliminateDash.capitalizingFirstLetter()})
        selectedPokedex = pokedexNames.first ?? ""
    }
    
    private func getPokemons(from url: String) {
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
    
    private func getLocation(from url: String) {
        if url.isEmpty { return }
        Session.share.location(from: url)
            .replaceError(with: Location())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.location = location
            }.store(in: &cancellables)
    }
    
    private func getArea(from url: String) {
        if url.isEmpty { return }
        Session.share.area(from: url)
            .replaceError(with: LocationArea())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] area in
                guard let self = self else { return }
                self.areaPokedexCellModels = self.getPokemonCellModels(form: area)
            }.store(in: &cancellables)
    }
    
    private func getPokemonCellModels(form area: LocationArea) -> [AreaPokedexCellModel] {
        if area.pokemons.isEmpty { return [] }
        return area.pokemons.map {AreaPokedexCellModel(encounter: $0, url: $0.pokemon.url)}
    }
}
