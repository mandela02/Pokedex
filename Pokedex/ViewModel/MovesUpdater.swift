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

struct GroupedMoveCellModel: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var cells: [MoveCellModel] = []
}

class MovesUpdater: ObservableObject {
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            pokemonMoves = pokemon.moves ?? []
        }
    }
    
    @Published var pokemonMoves: [PokemonMove] = [] {
        didSet {
            if !pokemonMoves.isEmpty {
                getAllMoves()
            }
        }
    }
    
    @Published var moves: [Move] = [] {
        didSet {
            var list: [MoveCellModel] = []
            for (index, move) in moves.enumerated() {
                list.append(MoveCellModel(pokemonMove: pokemonMoves[safe: index] ?? PokemonMove(), move: move))
            }
            moveCellModels = list
        }
    }
    
    @Published var moveCellModels: [MoveCellModel] = [] {
        didSet {
            groupedMoveCellModels = Dictionary(grouping: moveCellModels,
                                               by: {($0.move.type?.name ?? "No Name")})
                //.map({GroupedMoveCellModel(name: $0.key, cells: $0.value)})
                .map({SectionModel(isExpanded: true, title: $0.key, data: $0.value)})
        }
    }
    
    @Published var groupedMoveCellModels: [SectionModel<MoveCellModel>] = []
    @Published var selected: String?
    @Published var error: ApiError = .non

    private var cancellables = Set<AnyCancellable>()
    
    private func getAllMoves() {
        Publishers.Sequence(sequence: pokemonMoves.map({Session.share.move(from: $0.move.url)}))
            .flatMap({$0})
            .collect()
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
                self.moves = result
            }).store(in: &cancellables)
    }
}
