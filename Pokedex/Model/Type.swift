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
    var moveDamageClass: NamedAPIResource = NamedAPIResource()

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
    
    var color: PokemonColor {
        switch self {
        case .normal:
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
        case .fighting:
            return PokemonColor(background: Color(hex: "C03028"),
                                text: .white,
                                type: Color(hex: "C03028"))
        case .flying:
            //chua có
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
        case .poison:
            return PokemonColor(background: Color(hex: "A040A0"),
                                text: .white,
                                type: Color(hex: "A040A0"))
        case .ground:
            return PokemonColor(background: Color(hex: "E0C068"),
                                text: .white,
                                type: Color(hex: "E0C068"))
        case .rock:
            return PokemonColor(background: Color(hex: "B8A038"),
                                text: .white,
                                type: Color(hex: "B8A038"))
        case .bug:
            return PokemonColor(background: Color(hex: "A8B820"),
                                text: .white,
                                type: Color(hex: "A8B820"))
        case .ghost:
            return PokemonColor(background: Color(hex: "705890"),
                                text: .white,
                                type: Color(hex: "705890"))
        case .steel:
            //CHUACO
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
        case .fire:
            return PokemonColor(background: Color(hex: "F08030"),
                                text: .white,
                                type: Color(hex: "F08030"))
        case .water:
            return PokemonColor(background: Color(hex: "6890F0"),
                                text: .white,
                                type: Color(hex: "6890F0"))
        case .grass:
            return PokemonColor(background: Color(hex: "78C850"),
                                text: .white,
                                type: Color(hex: "78C850"))
        case .electric:
            return PokemonColor(background: Color(hex: "F8D030"),
                                text: .white,
                                type: Color(hex: "F8D030"))

        case .psychic:
            return PokemonColor(background: Color(hex: "F85888"),
                                text: .white,
                                type: Color(hex: "F85888"))
        case .ice:
            return PokemonColor(background: Color(hex: "98D8D8"),
                                text: .white,
                                type: Color(hex: "98D8D8"))
        case .dragon:
            return PokemonColor(background: Color(hex: "7038F8"),
                                text: .white,
                                type: Color(hex: "7038F8"))
        case .dark:
            //CHUACO
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
        case .fairy:
            return PokemonColor(background: Color(hex: "EE99AC"),
                                text: .white,
                                type: Color(hex: "EE99AC"))
        case .unknown:
            //CHUACO
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
        case .shadow:
            //CHUACO
            return PokemonColor(background: Color(hex: "A8A878"),
                                text: .white,
                                type: Color(hex: "A8A878"))
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
        }
        return baseURL + "\(id)"
    }
    
    static func type(from string: String?) -> PokemonType {
        guard let string = string else { return .normal }
        if let index = allCases.map({$0.rawValue}).firstIndex(of: string) {
            return allCases[index]
        }
        return .normal
    }
}
