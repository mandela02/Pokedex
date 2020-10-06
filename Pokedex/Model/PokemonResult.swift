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
    var results: [PokemonUrl] = []
}

class PokemonUrl: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var url: String = ""
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
