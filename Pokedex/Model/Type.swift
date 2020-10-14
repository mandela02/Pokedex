//
//  type.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation

struct TypeResult: Codable {
    var slot: Int = 0
    var type: NamedAPIResource = NamedAPIResource(name: "", url: "")
}

struct TypePokemon: Codable {
    var slot: Int = 0
    var pokemon: NamedAPIResource = NamedAPIResource(name: "", url: "")
}

struct PokeType: Codable {
    var id: Int = 1
    var name: String = ""
    var pokemon: [TypePokemon] = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pokemon
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
