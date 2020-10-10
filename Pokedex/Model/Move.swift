//
//  Move.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct Move: Codable {
    var accuracy: Int
    var contestCombos: ContestCombos
    var contestEffect: APIResource
    var contestType: NamedAPIResource
    var damageClass: NamedAPIResource
    var effectChance: Int?
    var effectChanges: [AbilityEffectChange]
    var effectEntries: [EffectEntry]
    var flavorTextEntries: [FlavorTextEntry]
    var generation: NamedAPIResource
    var id: Int
    var machines: [MachineVersionDetail]
    var meta: Meta
    var name: String
    var names: [Name]
    var pastValues: [PastMoveStatValue]
    var power, pp, priority: Int
    var statChanges: [MoveStartChange]
    var superContestEffect: APIResource
    var target, type: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case accuracy
        case contestCombos = "contest_combos"
        case contestEffect = "contest_effect"
        case contestType = "contest_type"
        case damageClass = "damage_class"
        case effectChance = "effect_chance"
        case effectChanges = "effect_changes"
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case generation, id, machines, meta, name, names
        case pastValues = "past_values"
        case power, pp, priority
        case statChanges = "stat_changes"
        case superContestEffect = "super_contest_effect"
        case target, type
    }
}

struct MoveStartChange: Codable {
    var change: Int
    var stat: NamedAPIResource
}

struct PastMoveStatValue: Codable {
    var accuracy: Int
    var effectChance: Int?
    var effectEntries: [EffectEntry]
    var power: Int
    var pp: Int
    var type: NamedAPIResource?
    var versionGroup: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case accuracy
        case effectChance = "effect_chance"
        case effectEntries = "effect_entries"
        case power, pp, type
        case versionGroup = "version_group"
    }
}
