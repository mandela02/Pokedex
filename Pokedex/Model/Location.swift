//
//  Location.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import Foundation

struct Location: Codable {
    var id: Int = 0
    var areas: [NamedAPIResource] = []
}

struct LocationArea: Codable {
    var id: Int = 0
    var methodRates: [EncounterMethodRates] = []
    var pokemons: [PokemonEncounters] = []

    
    enum CodingKeys: String, CodingKey {
        case id
        case methodRates = "encounter_method_rates"
        case pokemons = "pokemon_encounters"
    }
}

struct EncounterMethodRates: Codable {
    var method: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case method = "encounter_method"
    }
}

struct PokemonEncounters: Codable {
    var pokemon: NamedAPIResource = NamedAPIResource()
    var detail: [PokemonVesionDetail] = []
    
    enum CodingKeys: String, CodingKey {
        case pokemon
        case detail = "version_details"
    }
}


struct PokemonVesionDetail: Codable {
    var maxChance: Int = 0
    var detail: [EncounterDetails] = []
    
    enum CodingKeys: String, CodingKey {
        case maxChance = "max_chance"
        case detail = "encounter_details"
    }
}

struct EncounterDetails: Codable {
    var chance: Int = 0
    var maxLvl: Int = 0
    var minLvl: Int = 0
    var method: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case chance
        case maxLvl = "max_level"
        case minLvl = "min_level"
        case method
    }
}



