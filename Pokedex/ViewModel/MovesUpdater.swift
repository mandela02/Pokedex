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
            getAllMoves()
        }
    }
    
    @Published var moves: [Move] = [] 
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selected: String?
    
    private func getAllMoves() {
        Publishers.Sequence(sequence: pokemonMoves.map({Session.share.move(from: $0.move.url)}))
            .flatMap({$0})
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.moves, on: self)
            .store(in: &cancellables)
    }

}
