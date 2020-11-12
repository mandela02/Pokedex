//
//  MoveDetailUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 11/11/2020.
//

import Foundation
import Combine

struct DetailMoveCellModel: Identifiable {
    var id = UUID()
    
    var pokemonMove = PokemonMove()
    var move = Move()
    var learnMethod = MoveLearnMethod()
    var machine = Machine()
    var target = MoveTarget()
}

class MoveDetailUpdater: ObservableObject {
    var pokemonMove = PokemonMove() {
        didSet {
            moveLearnMethodUrl = pokemonMove.versionGroupDetails.first?.moveLearnMethod.url ?? ""
        }
    }
    
    var move: Move = Move() {
        didSet {
            machineUrl = move.machines?.first?.machine.url ?? ""
            targetUrl = move.target?.url ?? ""
        }
    }
    @Published var moveLearnMethodUrl = ""
    @Published var machineUrl = ""
    @Published var targetUrl = ""
    @Published var moveCellModel = DetailMoveCellModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
    }
}

extension MoveDetailUpdater {
    private func target(from url: String) -> AnyPublisher<MoveTarget, Never> {
        if url.isEmpty {
            return CurrentValueSubject<MoveTarget, Never>(MoveTarget()).eraseToAnyPublisher()
        }
        
        return Session.share.moveTarget(from: url)
            .replaceError(with: MoveTarget())
            .eraseToAnyPublisher()
    }
    
    private func machine(from url: String) -> AnyPublisher<Machine, Never> {
        if url.isEmpty {
            return CurrentValueSubject<Machine, Never>(Machine()).eraseToAnyPublisher()
        }
        
        return Session.share.machine(from: url)
            .replaceError(with: Machine())
            .eraseToAnyPublisher()
    }
    
    private func moveLearnMethod(from url: String) -> AnyPublisher<MoveLearnMethod, Never> {
        if url.isEmpty {
            return CurrentValueSubject<MoveLearnMethod, Never>(MoveLearnMethod()).eraseToAnyPublisher()
        }
        
        return Session.share.moveLearnMethod(from: url)
            .replaceError(with: MoveLearnMethod())
            .eraseToAnyPublisher()
    }
    
    private func zip(moveLearnMethodUrl: String, machineUrl: String, targetUrl: String) -> AnyPublisher<(MoveLearnMethod, Machine, MoveTarget), Never> {
        Publishers.Zip3(moveLearnMethod(from: moveLearnMethodUrl),
                        machine(from: machineUrl),
                        target(from: targetUrl))
            .eraseToAnyPublisher()
    }
    
    private func getData() {
        Publishers.CombineLatest3($moveLearnMethodUrl,
                                  $machineUrl,
                                  $targetUrl)
            .flatMap { [weak self] (moveLearnMethodUrl, machineUrl, targetUrl) -> AnyPublisher<(MoveLearnMethod, Machine, MoveTarget), Never>  in
                guard let self = self else {
                    return CurrentValueSubject<(MoveLearnMethod, Machine, MoveTarget), Never>((MoveLearnMethod(), Machine(), MoveTarget()))
                        .eraseToAnyPublisher()
                }
                
                return self.zip(moveLearnMethodUrl: String(moveLearnMethodUrl),
                                machineUrl: String(machineUrl),
                                targetUrl: String(targetUrl))
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] moveLearnMethod, machine, moveTarget in
                guard let self = self else { return }
                self.moveCellModel = DetailMoveCellModel(pokemonMove: self.pokemonMove,
                                                         move: self.move,
                                                         learnMethod: moveLearnMethod ,
                                                         machine: machine,
                                                         target: moveTarget)
            })
            .store(in: &cancellables)
    }
}
