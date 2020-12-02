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
    var pokemonUrl: String
    var speciesUrl: String
    var location: String
    var area: String
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
            isLoadingData = true

            if firstTimeLoading && selectedLocation != "default" {
                regionName = selectedLocation
                firstTimeLoading = false
            }
            
            if selectedLocation == regionName {
                areaPokedexCellModels.safeRemoveAll()
                areaNames.safeRemoveAll()
                selectedArea = ""
                getPokedex(from: region)
            } else {
                pokedexCellModels.safeRemoveAll()
                pokedexNames.safeRemoveAll()
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
            if pokedexNames.isEmpty {
                isLoadingData = false
            }
        }
    }
    @Published var isHavingMultiDex = false
    
    @Published var selectedPokedex: String = "" {
        didSet {
            guard selectedPokedex != oldValue else { return }
            isLoadingData = true
            guard let region = region else { return }
            let pokedexs = region.pokedexes
            if pokedexs.isEmpty { return }
            let currentDex = selectedPokedex.lowercased()
            if let pokedexUrl = pokedexs.first(where: {$0.name.eliminateDash == currentDex})?.url {
                getPokemons(from: pokedexUrl)
            }
        }
    }
    @Published var pokedexCellModels: [PokedexCellModel] = [] {
        didSet {
            if neededToShowDex {
                isLoadingData = false
            }
            if pokedexCellModels.isEmpty {
                isLoadingData = false
            }
        }
    }
    
    @Published var areaPokedexCellModels: [AreaPokedexCellModel] = [] {
        didSet {
            if !neededToShowDex {
                isLoadingData = false
            }
            if areaPokedexCellModels.isEmpty {
                isLoadingData = false
            }
        }
    }

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
            if areaNames.isEmpty {
                isLoadingData = false
            }
        }
    }
    @Published var isHavingMultiArea = false
    
    @Published var selectedArea = "" {
        didSet {
            guard selectedArea != oldValue else { return }
            isLoadingData = true

            guard let location = location else { return }
            let areas = location.areas
            if areas.isEmpty { return }
            let currentArea = selectedArea.lowercased()
            if let pokedexUrl = areas.first(where: {$0.name.eliminateDash == currentArea})?.url {
                getArea(from: pokedexUrl)
            }
        }
    }

    @Published var isLoadingData = true
    
    @Published var searchValue: String = ""
    
    @Published var searchResult: [String] = []
    
    @Published var havingNoPokemons = false

    init() {
        searching()
        
        $isLoadingData
            .dropFirst(5)
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else {
                    return
                }
                self.havingNoPokemons = result ? false : self.pokedexCellModels.isEmpty && self.areaPokedexCellModels.isEmpty
            })
            .store(in: &cancellables)

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
        if url.isEmpty {
            isLoadingData = false
            return
        }
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
            .map({PokedexCellModel(pokemonUrl: UrlString.getPokemonUrl(of: StringHelper.getPokemonId(from: $0.species.url)),
                                   speciesUrl: $0.species.url)})
    }
    
    private func getLocation(from url: String) {
        if url.isEmpty {
            isLoadingData = false
            return
        }
        Session.share.location(from: url)
            .replaceError(with: Location())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.location = location
            }.store(in: &cancellables)
    }
    
    private func getArea(from url: String) {
        if url.isEmpty {
            isLoadingData = false
            return
        }
        Session.share.area(from: url)
            .replaceError(with: LocationArea())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] area in
                guard let self = self else { return }
                self.areaPokedexCellModels = self.getPokemonCellModels(form: area)
            }.store(in: &cancellables)
    }
    
    private func getPokemonCellModels(form area: LocationArea) -> [AreaPokedexCellModel] {
        if area.pokemons.isEmpty {
            isLoadingData = false
            return []
        }
        return area.pokemons.map { [weak self] in
            guard let self = self else { return nil }
            return AreaPokedexCellModel(encounter: $0,
                                 pokemonUrl: $0.pokemon.url,
                                 speciesUrl: UrlString.getSpeciesUrl(from: StringHelper.getSpeciesName(from: $0.pokemon.name)),
                                 location: self.selectedLocation,
                                 area: self.selectedArea)
        }.compactMap( {$0} )
    }
    
    private func searching() {
        $searchValue
            .receive(on: RunLoop.main)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] searchString in
                guard let self = self else { return }
                let lowString = searchString.lowercased()
                self.searchResult = self.locations.filter({$0.lowercased().contains(lowString)})
            }).store(in: &cancellables)
    }
}
