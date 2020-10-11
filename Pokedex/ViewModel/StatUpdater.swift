//
//  StatUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation
import Combine

class StatUpdater: ObservableObject {
    @Published var pokemon: Pokemon = Pokemon()
    
    @Published var numbers: [PokeStatUrl] = [] {
        didSet {
            getMaxStat()
        }
    }
    
    @Published var stat: Stat = Stat() {
        didSet {
            getCharacteristic(of: stat)
        }
    }
    
    @Published var characteristics: [Characteristic] = [] {
        didSet {
            if !characteristics.isEmpty {
                descriptions = characteristics
                    .map({StringHelper.createEnglishText(from: $0.descriptions)})
            }
        }
    }
    @Published var descriptions: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init(of pokemon: Pokemon) {
        self.pokemon = pokemon
        getNumbers(of: pokemon)
    }
        
    private func getNumbers(of pokemon: Pokemon) {
        let allStat = pokemon.stats.map({$0.baseStat}).reduce(0, +)
        numbers = pokemon.stats + [PokeStatUrl(statUrl: NamedAPIResource(name: "Total", url: ""), baseStat: allStat)]
    }
    
    private func getMaxStat() {
        let max = pokemon.stats.max(by: {$0.baseStat < $1.baseStat})
        if let statUrl = max?.statUrl.url {
            Session.share.stat(from: statUrl)
                .replaceError(with: Stat())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
                .assign(to: \.stat, on: self)
                .store(in: &cancellables)
        }
    }
    
    private func getCharacteristic(of stat: Stat) {
        let statsUrl = stat.characteristics.map({$0.url})
        statsUrl
            .map({Session.share.characteristic(from: $0).eraseToAnyPublisher()})
            .publisher
            .flatMap({$0})
            .replaceError(with: Characteristic())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .collect()
            .assign(to: \.characteristics, on: self)
            .store(in: &cancellables)
    }
}
