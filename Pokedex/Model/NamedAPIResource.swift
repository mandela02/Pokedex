//
//  BasePokemonUrlResult.swift
//  Pokedex
//
//  Created by TriBQ on 07/10/2020.
//

import Foundation

struct NamedAPIResource: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var url: String = ""
        
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
