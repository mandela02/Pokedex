//
//  Move.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct Move: Codable, Identifiable {
    var id = UUID()
    var effectEntries: [EffectEntry]?
    var flavorTextEntries: [MoveFlavorTextEntry]?
    var moveId: Int?
    var machines: [MachineVersionDetail]?
    var name: String?
    var power, pp, priority: Int?
    var target, type: NamedAPIResource?

    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case power, pp, priority
        case target, type
        case moveId = "id"
        case name
        case machines
    }
}

class MoveFlavorTextEntry: Codable {
    var flavorText: String?
    var language: NamedAPIResource?
    var version: NamedAPIResource?

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version = "version_group"
    }
}
