//
//  Color.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import SwiftUI

struct PokemonColor {
    var background: Color
    var text: Color
    var type: Color
}

enum PokemonType {
    case fire
    case water
    case grass
    
    var color: PokemonColor {
        switch self {
        case .fire:
            return PokemonColor(background: .red,
                                text: .white,
                                type: .gray)
        case .water:
            return PokemonColor(background: .blue,
                                text: .white,
                                type: .gray)
        case .grass:
            return PokemonColor(background: .green,
                                text: .white,
                                type: .gray)
        }
    }
}
