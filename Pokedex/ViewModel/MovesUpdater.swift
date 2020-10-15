//
//  MovesUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import Foundation
import Combine

struct MoveCellModel: Identifiable {
    var id = UUID()
    
    var pokemonMove = PokemonMove()
    var move = Move()
}

class MovesUpdater: ObservableObject {
    @Published var pokemonMoves: [PokemonMove] = [] {
        didSet {
            getAllMoves()
        }
    }
    
    @Published var moves: [Move] = [] {
        didSet {
            var cells: [MoveCellModel] = []
            for (index, move) in moves.enumerated() {
                cells.append(MoveCellModel(pokemonMove: pokemonMoves[safe: index] ?? PokemonMove(), move: move))
            }
            moveCellModels = cells
        }
    }
    @Published var selected: String?
    @Published var moveCellModels: [MoveCellModel] = []

    private var cancellables = Set<AnyCancellable>()
    
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
