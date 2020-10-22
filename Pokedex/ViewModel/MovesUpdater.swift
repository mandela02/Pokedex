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
    var learnMethod = MoveLearnMethod()
    var machine = Machine()
    var target = MoveTarget()
}

struct GroupedMoveCellModel: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var cells: [MoveCellModel] = []
}

class MovesUpdater: ObservableObject {
    init(of pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
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
            merge()
        }
    }
    @Published var moveCellModels: [MoveCellModel] = [] {
        didSet {
            groupedMoveCellModels = Dictionary(grouping: moveCellModels, by: {($0.move.type?.name ?? "No Name")}).map({GroupedMoveCellModel(name: $0.key, cells: $0.value)})
        }
    }
    @Published var groupedMoveCellModels: [GroupedMoveCellModel] = []
    @Published var selected: String?
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
    
    private func getMoveDetails() -> AnyPublisher<[MoveLearnMethod], Error> {
        let detailUrl = pokemonMoves.map({$0.versionGroupDetails.first?.moveLearnMethod.url}).compactMap({$0}).uniques
                
        return Publishers.Sequence(sequence: detailUrl.map({Session.share.moveLearnMethod(from: $0)}))
            .flatMap({$0})
            .replaceEmpty(with: MoveLearnMethod())
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func getMachine() -> AnyPublisher<[Machine], Error> {
        let machineUrl = moves.map({$0.machines?.first?.machine.url}).compactMap({$0}).uniques
                
        return Publishers.Sequence(sequence: machineUrl.map({Session.share.machine(from: $0)}))
            .flatMap({$0})
            .replaceEmpty(with: Machine())
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func getTarget() -> AnyPublisher<[MoveTarget], Error>{
        let targetUrl = moves.map({ $0.target?.url}).compactMap({$0}).uniques
        
        return Publishers.Sequence(sequence: targetUrl.map({Session.share.moveTarget(from: $0)}))
            .flatMap({$0})
            .replaceEmpty(with: MoveTarget())
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func merge() {
        Publishers.Zip3(getMoveDetails(), getMachine(), getTarget())
            .receive(on: DispatchQueue.main)
            .replaceError(with: ([], [], []))
            .sink { [weak self] (moveLearnMethods, machines, targets) in
                guard let self = self else { return }
                var cells: [MoveCellModel] = []
                for (index, move) in self.moves.enumerated() {
                    let pokemonMove = self.pokemonMoves[safe: index] ?? PokemonMove()
                    let learnMethodName = pokemonMove.versionGroupDetails.first?.moveLearnMethod.name ?? ""
                    let machineId = StringHelper.getMachineId(from: move.machines?.first?.machine.url ?? "")
                    let targetName = move.target?.name ?? ""
                    let moveModel = MoveCellModel(pokemonMove: pokemonMove,
                                                  move: move,
                                                  learnMethod: moveLearnMethods.first(where: {$0.name == learnMethodName}) ?? MoveLearnMethod(),
                                                  machine: machines.first(where: {$0.id == machineId}) ?? Machine(),
                                                  target: targets.first(where: {$0.name == targetName}) ?? MoveTarget())
                    cells.append(moveModel)
                }
                self.moveCellModels = cells
            }
            .store(in: &cancellables)
    }
}
