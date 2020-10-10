//
//  Evolution.swift
//  Pokedex
//
//  Created by TriBQ on 09/10/2020.
//

struct Evolution: Codable {
    var babyTriggerItem: Item?
    var chain: EvolutionChain = EvolutionChain()
    var id: Int = 0

    enum CodingKeys: String, CodingKey {
        case babyTriggerItem = "baby_trigger_item"
        case chain
        case id
    }
}

struct EvolutionChain: Codable {
    var evolutionDetails: [EvolutionDetail] = []
    var evolvesTo: [EvolutionChain] = []
    var isBaby: Bool = false
    var species: NamedAPIResource = NamedAPIResource(name: "", url: "")

    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case isBaby = "is_baby"
        case species
    }
}

struct EvolutionDetail: Codable {
    var item: Item?
    var gender: Int?
    var heldItem: Item?
    var knownMove: NamedAPIResource?
    var knownMoveType: NamedAPIResource?
    var location: NamedAPIResource?
    var minAffection: NamedAPIResource?
    var minBeauty: Int?
    var minHappiness: Int?
    var minLevel: Int
    var needsOverworldRain: Bool
    var partySpecies: NamedAPIResource?
    var partyType: NamedAPIResource?
    var relativePhysicalStats: Int?
    var timeOfDay: String
    var tradeSpecies: NamedAPIResource?
    var trigger: NamedAPIResource
    var turnUpsideDown: Bool

    enum CodingKeys: String, CodingKey {
        case gender
        case heldItem = "held_item"
        case item
        case knownMove = "known_move"
        case knownMoveType = "known_move_type"
        case location
        case minAffection = "min_affection"
        case minBeauty = "min_beauty"
        case minHappiness = "min_happiness"
        case minLevel = "min_level"
        case needsOverworldRain = "needs_overworld_rain"
        case partySpecies = "party_species"
        case partyType = "party_type"
        case relativePhysicalStats = "relative_physical_stats"
        case timeOfDay = "time_of_day"
        case tradeSpecies = "trade_species"
        case trigger
        case turnUpsideDown = "turn_upside_down"
    }
}

struct Item: Codable {
    var attributes: [NamedAPIResource] = []
    var babyTriggerFor: APIResource?
    var category: NamedAPIResource
    var cost: Int
    var effectEntries: [EffectEntry]
    var flavorTextEntries: [FlavorTextEntry]
    var flingEffect: NamedAPIResource?
    var flingPower: Int?
    var gameIndices: [GameIndex]
    var heldByPokemon: [ItemHolderPokemon]
    var id: Int
    var machines: [MachineVersionDetail]
    var name: String
    var names: [Name]
    var sprites: Sprites

    enum CodingKeys: String, CodingKey {
        case attributes
        case babyTriggerFor = "baby_trigger_for"
        case category, cost
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case flingEffect = "fling_effect"
        case flingPower = "fling_power"
        case gameIndices = "game_indices"
        case heldByPokemon = "held_by_pokemon"
        case id, machines, name, names, sprites
    }
}

struct EffectEntry: Codable {
    var effect: String
    var language: NamedAPIResource
    var shortEffect: String

    enum CodingKeys: String, CodingKey {
        case effect, language
        case shortEffect = "short_effect"
    }
}

struct GameIndex: Codable {
    var gameIndex: Int
    var generation: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case generation
    }
}

struct Name: Codable {
    var language: NamedAPIResource
    var name: String
}

struct Sprites: Codable {
    var spritesDefault: String

    enum CodingKeys: String, CodingKey {
        case spritesDefault = "default"
    }
}

struct ContestCombos: Codable {
    var normal, contestCombosSuper: ContestComboDetail

    enum CodingKeys: String, CodingKey {
        case normal
        case contestCombosSuper = "super"
    }
}

struct ContestComboDetail: Codable {
    var useAfter:  [NamedAPIResource]
    var useBefore: [NamedAPIResource]?

    enum CodingKeys: String, CodingKey {
        case useAfter = "use_after"
        case useBefore = "use_before"
    }
}
