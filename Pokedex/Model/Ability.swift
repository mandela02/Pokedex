//
//  Ability.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation


struct AbilityEffectChange: Codable {
    var effectEntries: [EffectEntry]
    var versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case versionGroup = "version_group"
    }
}

struct Ability: Codable {
    var effectEntries: [EffectEntry]?
    var flavorTextEntries: [FlavorTextEntry]?

    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
    }
}
