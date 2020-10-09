//
//  StatUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation

class StatUpdater: ObservableObject {
    @Published var stats: [PokeStat] = []
    
    init(stats: [PokeStat]) {
    }
}
