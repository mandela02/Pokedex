//
//  MoveDetailUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 17/10/2020.
//

import Foundation
import Combine

class MoveDetailUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    @Published var pokemonMove: PokemonMove = PokemonMove() {
        didSet {
            getMoveDetail()
        }
    }
    
    @Published var move: Move = Move() {
        didSet {
            getMachine()
            getTarget()
        }
    }
    @Published var moveLearnMethod: MoveLearnMethod = MoveLearnMethod()
    @Published var machine: Machine = Machine()
    @Published var moveTarget: MoveTarget = MoveTarget()
    
    private func getMoveDetail() {
        Session.share.moveLearnMethod(from: pokemonMove.versionGroupDetails.first?.moveLearnMethod.url ?? "")
            .replaceError(with: MoveLearnMethod())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.moveLearnMethod, on: self)
            .store(in: &cancellables)
    }
    
    private func getMachine() {
        Session.share.machine(from: move.machines?.first?.machine.url ?? "")
            .replaceError(with: Machine())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.machine, on: self)
            .store(in: &cancellables)
    }
    
    private func getTarget() {
        Session.share.moveTarget(from: move.target?.url ?? "")
            .replaceError(with: MoveTarget())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.moveTarget, on: self)
            .store(in: &cancellables)
    }
}
