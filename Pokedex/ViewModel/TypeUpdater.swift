//
//  TypeUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 14/10/2020.
//

import Foundation
import Combine

struct TypeCell: Identifiable {
    var id: Int {
        type.id
    }
    var type: PokeType
    var cells: [PokemonCellModel]
}

class TypeUpdater: ObservableObject {
    @Published var allTypes: [PokemonType] = PokemonType.allCases
}
