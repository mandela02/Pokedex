//
//  PokemonResult.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation

class PokemonResult: Codable {
    var count: Int = 0
    var next: String?
    var previous: String?
    var results: [BasePokemonUrlResult] = []
}
