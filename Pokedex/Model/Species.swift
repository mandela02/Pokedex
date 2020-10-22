//
//  Species.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation

struct Species: Codable {
    var id: Int = 0
    var name: String?
    var flavorTextEntries: [FlavorTextEntry]?
    var genderRate: Int?
    var eggGroup: [NamedAPIResource]?
    var habitat: NamedAPIResource?
    var evolutionChain: APIResource?
    var varieties: [PokemonSpeciesVariety]?
    var genera: [Genus]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case flavorTextEntries = "flavor_text_entries"
        case genderRate = "gender_rate"
        case eggGroup = "egg_groups"
        case habitat
        case evolutionChain = "evolution_chain"
        case varieties
        case genera
    }
    
    var havingMega: Bool {
        return !megas.isEmpty
    }
    
    var megas: [NamedAPIResource] {
        return varieties?.map({$0.pokemon}).filter({$0.name.contains("mega")}) ?? []
    }
    
    var pokemon: NamedAPIResource {
        return varieties?.filter({$0.isDefault}).first?.pokemon ?? NamedAPIResource()
    }
}

struct FlavorTextEntry: Codable {
    var flavorText: String = ""
    var language: NamedAPIResource = NamedAPIResource()
    var version: NamedAPIResource = NamedAPIResource()

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
}

struct PokemonSpeciesVariety: Codable {
    var isDefault: Bool = true
    var pokemon: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}

struct Genus: Codable {
    var genus: String = ""
    var language: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case genus
        case language
    }
}
