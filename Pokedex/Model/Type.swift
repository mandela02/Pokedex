//
//  type.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation
import SwiftUI

struct PokemonOfType: Codable {
    var slot: Int = 0
    var pokemon: NamedAPIResource = NamedAPIResource()
}

struct PokeType: Codable {
    var id: Int = 1
    var name: String = ""
    var pokemon: [PokemonOfType] = []
    var moveDamageClass: NamedAPIResource?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pokemon
        case moveDamageClass = "move_damage_class"
    }
}

struct DamageRelations: Codable {
    var doubleDamageFrom: [NamedAPIResource]
    var doubleDamageTo: [NamedAPIResource]
    var halfDamageFrom: [NamedAPIResource]
    var halfDamageTo, noDamageFrom, noDamageTo: [NamedAPIResource]

    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}

enum PokemonType: String, CaseIterable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
    case non
    
    var color: PokemonColor {
        switch self {
        case .normal:
            return PokemonColor(background: Color(hex: "6D6D4E"),
                                text: .white,
                                type: Color(hex: "C6C6A7"))
        case .fighting:
            return PokemonColor(background: Color(hex: "7D1F1A"),
                                text: .white,
                                type: Color(hex: "D67873"))
        case .flying:
            return PokemonColor(background: Color(hex: "6D5E9C"),
                                text: .white,
                                type: Color(hex: "C6B7F5"))
        case .poison:
            return PokemonColor(background: Color(hex: "682A68"),
                                text: .white,
                                type: Color(hex: "C183C1"))
        case .ground:
            return PokemonColor(background: Color(hex: "927D44"),
                                text: .white,
                                type: Color(hex: "EBD69D"))
        case .rock:
            return PokemonColor(background: Color(hex: "786824"),
                                text: .white,
                                type: Color(hex: "D1C17D"))
        case .bug:
            return PokemonColor(background: Color(hex: "6D7815"),
                                text: .white,
                                type: Color(hex: "C6D16E"))
        case .ghost:
            return PokemonColor(background: Color(hex: "493963"),
                                text: .white,
                                type: Color(hex: "A292BC"))
        case .steel:
            return PokemonColor(background: Color(hex: "787887"),
                                text: .white,
                                type: Color(hex: "D1D1E0"))
        case .fire:
            return PokemonColor(background: Color(hex: "9C531F"),
                                text: .white,
                                type: Color(hex: "F5AC78"))
        case .water:
            return PokemonColor(background: Color(hex: "445E9C"),
                                text: .white,
                                type: Color(hex: "9DB7F5"))
        case .grass:
            return PokemonColor(background: Color(hex: "4E8234"),
                                text: .white,
                                type: Color(hex: "A7DB8D"))
        case .electric:
            return PokemonColor(background: Color(hex: "A1871F"),
                                text: .white,
                                type: Color(hex: "FAE078"))
        case .psychic:
            return PokemonColor(background: Color(hex: "A13959"),
                                text: .white,
                                type: Color(hex: "FA92B2"))
        case .ice:
            return PokemonColor(background: Color(hex: "638D8D"),
                                text: .white,
                                type: Color(hex: "BCE6E6"))
        case .dragon:
            return PokemonColor(background: Color(hex: "4924A1"),
                                text: .white,
                                type: Color(hex: "A27DFA"))
        case .dark:
            return PokemonColor(background: Color(hex: "49392F"),
                                text: .white,
                                type: Color(hex: "A29288"))
        case .fairy:
            return PokemonColor(background: Color(hex: "9B6470"),
                                text: .white,
                                type: Color(hex: "F4BDC9"))
        case .unknown:
            return PokemonColor(background: Color(hex: "44685E"),
                                text: .white,
                                type: Color(hex: "9DC1B7"))
        case .shadow:
            return PokemonColor(background: Color(hex: "9966cc"),
                                text: .white,
                                type: Color(hex: "551A8B"))
        case .non:
            return PokemonColor(background: Color(.systemGray4),
                                text: .white,
                                type: Color(.systemGray4))
        }
    }
    
    var url: String {
        let baseURL = "https://pokeapi.co/api/v2/type/"
        var id = 0
        switch self {
        case .normal:
            id = 1
        case .fighting:
            id = 2
        case .flying:
            id = 3
        case .poison:
            id = 4
        case .ground:
            id = 5
        case .rock:
            id = 6
        case .bug:
            id = 7
        case .ghost:
            id = 8
        case .steel:
            id = 9
        case .fire:
            id = 10
        case .water:
            id = 11
        case .grass:
            id = 12
        case .electric:
            id = 13
        case .psychic:
            id = 14
        case .ice:
            id = 15
        case .dragon:
            id = 16
        case .dark:
            id = 17
        case .fairy:
            id = 18
        case .unknown:
            id = 10001
        case .shadow:
            id = 10002
        case .non:
            id = 0
        }
        return baseURL + "\(id)"
    }
    
    static func type(from string: String?) -> PokemonType {
        guard let string = string else { return .non }
        if let index = allCases.map({$0.rawValue}).firstIndex(of: string) {
            return allCases[index]
        }
        return .non
    }
}
