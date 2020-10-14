//
//  Stat.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct Stat: Codable {
    var affectingMoves: MoveStatAffectSets = MoveStatAffectSets()
    var affectingNatures: NatureStatAffectSets = NatureStatAffectSets()
    var characteristics: [APIResource] = []
    var gameIndex: Int = 0
    var id: Int = 0
    var isBattleOnly: Bool = false
    var moveDamageClass: NamedAPIResource?
    var name: String?
    var names: [Name] = []

    enum CodingKeys: String, CodingKey {
        case affectingMoves = "affecting_moves"
        case affectingNatures = "affecting_natures"
        case characteristics
        case gameIndex = "game_index"
        case id
        case isBattleOnly = "is_battle_only"
        case moveDamageClass = "move_damage_class"
        case name, names
    }
}

// MARK: - AffectingMoves
struct MoveStatAffectSets: Codable {
    var decrease: [MoveStatAffect] = []
    var increase: [MoveStatAffect] = []
}

struct MoveStatAffect: Codable {
    var change: Int = 0
    var move: NamedAPIResource = NamedAPIResource()
}

// MARK: - AffectingNatures
struct NatureStatAffectSets: Codable {
    var decrease: [NamedAPIResource] = []
    var increase: [NamedAPIResource] = []
}

struct Characteristic: Codable, Identifiable {
    var id = UUID().uuidString

    var descriptions: [Description] = []
    var geneModulo: Int = 0
    var highestStat: NamedAPIResource = NamedAPIResource()
    var pokeId: Int = 0
    var possibleValues: [Int] = []

    enum CodingKeys: String, CodingKey {
        case descriptions
        case geneModulo = "gene_modulo"
        case highestStat = "highest_stat"
        case pokeId = "id"
        case possibleValues = "possible_values"
    }
}

struct Description: Codable, Identifiable {
    var id = UUID().uuidString
    
    var description: String = ""
    var language: NamedAPIResource = NamedAPIResource()

    enum CodingKeys: String, CodingKey {
        case description = "description"
        case language
    }
}
