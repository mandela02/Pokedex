//
//  RegionUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import Foundation
import Combine

struct RegionCellModel: Identifiable {
    var id: String {
        name
    }
    
    var name: String
    var url: String
    var avatars: [Int]
}

class RegionUpdater: ObservableObject {
    private var cancelables = Set<AnyCancellable>()
    private var regionResult: PokemonResult? {
        didSet {
            guard let regionResult = regionResult else {
                return
            }
            regionCellModels = regionResult.results
                .map({RegionCellModel(name: $0.name,
                                      url: $0.url,
                                      avatars: RegionAvatars.region(from: $0.name).avatar)})
                .filter({!$0.avatars.isEmpty})
        }
    }
    
    @Published var regionCellModels: [RegionCellModel] = []
    
    init() {
        getAllRegion()
    }
    
    func getAllRegion() {
        Session.share.overallResult(from: UrlType.region.urlString)
            .replaceError(with: PokemonResult())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.regionResult = result
            })
            .store(in: &cancelables)
    }
}
