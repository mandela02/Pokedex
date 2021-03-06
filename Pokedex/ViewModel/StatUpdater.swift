//
//  StatUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation
import Combine

class StatUpdater: ObservableObject {
    
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            getNumbers(of: pokemon)
        }
    }
    
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
                    .map({StringHelper.getEnglishText(from: $0.descriptions)})
            }
        }
    }
    @Published var descriptions: [String] = []

    @Published var error: ApiError = .non

    private var cancellables = Set<AnyCancellable>()
        
    private func getNumbers(of pokemon: Pokemon) {
        let allStat = pokemon.stats.map({$0.baseStat}).reduce(0, +)
        numbers = pokemon.stats + [PokeStatUrl(statUrl: NamedAPIResource(name: "Total", url: ""), baseStat: allStat)]
    }
    
    private func getMaxStat() {
        let max = pokemon.stats.max(by: {$0.baseStat < $1.baseStat})
        if let statUrl = max?.statUrl.url {
            Session.share.stat(from: statUrl)
                .receive(on: DispatchQueue.main)
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
                    self.stat = result
                })
                .store(in: &cancellables)
        }
    }
    
    private func getCharacteristic(of stat: Stat) {
        let statsUrl = stat.characteristics.map({$0.url})
        statsUrl
            .map({Session.share.characteristic(from: $0).eraseToAnyPublisher()})
            .publisher
            .flatMap({$0})
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .collect()
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
                self.characteristics = result
            })
            .store(in: &cancellables)
    }
}
