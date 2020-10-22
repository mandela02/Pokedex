//
//  TypeUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import Foundation
import Combine

class TypeUpdater: ObservableObject {
    @Published var allTypes: [PokemonType] = PokemonType.allCases.filter({$0 != .non})
}
