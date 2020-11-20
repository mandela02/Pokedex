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
    @Published var selectedPokedex: String = ""

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
}
