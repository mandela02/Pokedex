//
//  BasePokemonUrlResult.swift
//  Pokedex
//
//  Created by TriBQ on 07/10/2020.
//

import Foundation

class NamedAPIResource: Codable, Identifiable {
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
