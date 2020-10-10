//
//  Meta.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct Meta: Codable {
    var ailment: NamedAPIResource
    var ailmentChance: Int
    var category: NamedAPIResource
    var critRate: Int
    var drain: Int
    var flinchChance: Int
    var healing: Int
    var maxHits: Int
    var maxTurns: Int
    var minHits: Int
    var minTurns: Int
    var statChance: Int

    enum CodingKeys: String, CodingKey {
        case ailment
        case ailmentChance = "ailment_chance"
        case category
        case critRate = "crit_rate"
        case drain
        case flinchChance = "flinch_chance"
        case healing
        case maxHits = "max_hits"
        case maxTurns = "max_turns"
        case minHits = "min_hits"
        case minTurns = "min_turns"
        case statChance = "stat_chance"
    }
}
