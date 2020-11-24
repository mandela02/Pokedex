//
//  Pokedex.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import Foundation

struct Pokedex: Codable {
    var id: Int = 0
    var pokemons: [PokemonEntrie] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case pokemons = "pokemon_entries"
    }
}

struct PokemonEntrie: Codable {
    var number: Int = 0
    var species: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case number = "entry_number"
        case species = "pokemon_species"
    }
}
