//
//  Species.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation

class Species: Codable {
    var name: String = ""
    var baseHappiness: Int = 0
    var flavorTextEntries: [FlavorTextEntry] = []
    var genderRate: Int = 1
    var eggGroup: [BasePokemonUrlResult] = []
    var habitat: BasePokemonUrlResult = BasePokemonUrlResult(name: "", url: "")
    
    enum CodingKeys: String, CodingKey {
        case name
        case baseHappiness = "base_happiness"
        case flavorTextEntries = "flavor_text_entries"
        case genderRate = "gender_rate"
        case eggGroup = "egg_groups"
        case habitat
    }
}

class FlavorTextEntry: Codable {
    var flavorText: String = ""
    var language: BasePokemonUrlResult = BasePokemonUrlResult(name: "", url: "")
    var version: BasePokemonUrlResult = BasePokemonUrlResult(name: "", url: "")

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
}
