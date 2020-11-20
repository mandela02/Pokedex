//
//  Evolution.swift
//  Pokedex
//
//  Created by TriBQ on 09/10/2020.
//

enum EvolutionTrigger {
    case level
    case trade
    case item
    case shed
}

protocol EvolutionVending {
    var items: [EvolutionChain] { get }
}

extension EvolutionVending {
    var allChains: [EvolutionChain] {
        let items = self.items
        return items + items.flatMap { $0.allChains }
    }
}

struct Evolution: Codable, EvolutionVending {
    var items: [EvolutionChain] {
        get {
            if let chain = chain {
                return [chain]
            } else {
                return []
            }
        }
    }
    
    var babyTriggerItem: Item?
    var chain: EvolutionChain?
    var id: Int = 0
    enum CodingKeys: String, CodingKey {
        case babyTriggerItem = "baby_trigger_item"
        case chain
        case id
    }
}

struct EvolutionChain: Codable, EvolutionVending {
    var items: [EvolutionChain] {
        return evolvesTo
    }
    
    var evolutionDetails: [EvolutionDetail] = []
    var evolvesTo: [EvolutionChain] = []
    var isBaby: Bool = false
    var species: NamedAPIResource = NamedAPIResource()
    
    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case evolvesTo = "evolves_to"
        case isBaby = "is_baby"
        case species
    }
}

struct EvolutionDetail: Codable {
    var item: NamedAPIResource?
    var gender: Int?
    var heldItem: NamedAPIResource?
    var knownMove: NamedAPIResource?
    var knownMoveType: NamedAPIResource?
    var location: NamedAPIResource?
    var minAffection: NamedAPIResource?
    var minBeauty: Int?
    var minHappiness: Int?
    var minLevel: Int?
    var needsOverworldRain: Bool?
    var partySpecies: NamedAPIResource?
    var partyType: NamedAPIResource?
    var relativePhysicalStats: Int?
    var timeOfDay: String?
    var tradeSpecies: NamedAPIResource?
    var trigger: NamedAPIResource?
    var turnUpsideDown: Bool?
    
    var evolutionTrigger: EvolutionTrigger {
        switch trigger?.name {
        case "level-up":
            return .level
        case "trade":
            return .trade
        case "use-item":
            return .item
        case "shed":
            return .shed

        default:
            return .level
        }
    }
    
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
