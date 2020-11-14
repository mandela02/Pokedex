//
//  PokedexCellUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 08/11/2020.
//

import Foundation
import Combine

class PokedexCellUpdater: ObservableObject {
    private var cancellable: Cancellable?
    @Published var error: ApiError = .non
    @Published var pokemon = Pokemon()
    
    deinit {
        cancellable?.cancel()
    }
    
    var url: String = "" {
        didSet {
            getPokemon(from: url)
        }
    }
    
    private func getPokemon(from url: String) {
        if url.isEmpty {
            pokemon = Pokemon()
            cancellable?.cancel()
            return
        }
        cancellable = Session.share.pokemon(from: url)
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
                self.pokemon = result
            })
    }
}
