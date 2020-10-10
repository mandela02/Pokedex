//
//  Item.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct ItemHolderPokemon: Codable {
    var pokemon: NamedAPIResource
    var versionDetails: [VersionDetail]

    enum CodingKeys: String, CodingKey {
        case pokemon
        case versionDetails = "version_details"
    }
}

struct VersionDetail: Codable {
    var rarity: Int
    var version: NamedAPIResource
}

struct Effect: Codable {
    var effect: String
    var language: NamedAPIResource
}

struct ItemFlingEffect: Codable {
    var id: Int
    var name: String
    var effectEntries: Effect
    var items: [NamedAPIResource]
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case id, name, items
    }
}
