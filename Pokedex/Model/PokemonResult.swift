//
//  PokemonResult.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation

struct PokemonResult: Codable {
    var count: Int = 0
    var next: String?
    var previous: String?
    var results: [NamedAPIResource] = []
}
