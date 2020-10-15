//
//  MovesUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import Foundation
import Combine

class MovesUpdater: ObservableObject {
    @Published var pokemonMoves: [PokemonMove] = [] {
        didSet {
        }
    }
    @Published var url: String = "" {
        didSet {
            getMoves(from: url)
        }
    }
    
    @Published var move: Move = Move() {
        didSet {
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selected: String?

    private func getMoves(from url: String) {
        Session.share.move(from: url)
            .replaceError(with: Move())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.move, on: self)
            .store(in: &cancellables)
    }
}
