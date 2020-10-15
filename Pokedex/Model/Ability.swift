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
