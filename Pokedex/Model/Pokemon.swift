//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import SwiftUI

enum PokeStat: Int, CaseIterable {
    case hp
    case attack
    case defense
    case spAtk
    case spDef
    case speed
    case total
    
    var title: String {
        switch self {
        case .hp:
            return "HP"
        case .attack:
            return "Attack"
        case .defense:
            return "Defense"
        case .spAtk:
            return "Sp.Atk"
        case .spDef:
            return "Sp.Def"
        case .speed:
            return "Speed"
        case .total:
            return "Total"
        }
    }
    
    var maxValue: Int {
        switch self {
        case .total:
            return (PokeStat.allCases.count - 1) * 240
        default:
            return 240
        }
    }
}

struct Pokemon: Codable, Identifiable {
    var id = UUID().uuidString
    
    var name: String = ""
    var types: [TypeResult] = []
    var sprites: PokemonImage = PokemonImage()
    var order: Int = 0
    var species: NamedAPIResource = NamedAPIResource()
    var height: Int = 0
    var weight: Int = 0
    var abilities: [AbilitiesResult]?
    var stats: [PokeStatUrl] = []
    var pokeId: Int = 0
    var moves: [PokemonMove]?
    var isDefault: Bool = false
    
    var mainType: PokemonType {
        return PokemonType.type(from: types.first?.type.name)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case types = "types"
        case sprites = "sprites"
        case order = "order"
        case species = "species"
        case height = "height"
        case weight = "weight"
        case abilities = "abilities"
        case stats
        case pokeId = "id"
        case moves = "moves"
        case isDefault = "is_default"
    }
}

struct PokemonImage: Codable {
    var back: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var front: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
    var other: OtherImageResult?
    var versions: Versions?

    enum CodingKeys: String, CodingKey {
        case back = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case front = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other
        case versions
    }
}

struct Versions: Codable {
    var generationV: GenerationV?
    
    enum CodingKeys: String, CodingKey {
        case generationV = "generation-v"
    }
}

struct GenerationV: Codable {
    var blackWhite: BlackImage?

    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

struct BlackImage: Codable {
    var animated: AnimatedImage?
}

struct AnimatedImage: Codable {
    var front: String?
    
    enum CodingKeys: String, CodingKey {
        case front = "front_default"
    }
}

struct OtherImage: Codable {
    var front: String?
    var frontFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case front = "front_default"
        case frontFemale = "front_female"
    }
}

struct OtherImageResult: Codable {
    var dreamWorld: OtherImage = OtherImage()
    var artwork: OtherImage = OtherImage()
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case artwork = "official-artwork"
    }
}

struct PokeStatUrl: Codable, Identifiable {
    var id = UUID().uuidString
    var baseStat: Int = 0
    var effort: Int = 0
    var statUrl: NamedAPIResource = NamedAPIResource()
    var stat: PokeStat? {
        switch statUrl.name {
        case "hp":
            return .hp
        case "attack":
            return .attack
        case "defense":
            return .defense
        case "special-defense":
            return .spDef
        case "special-attack":
            return .spAtk
        case "speed":
            return .speed
        default:
            return .total
        }
    }
    
    init(statUrl: NamedAPIResource, baseStat: Int) {
        self.statUrl = statUrl
        self.baseStat = baseStat
    }
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case statUrl = "stat"
    }
}

struct TypeResult: Codable {
    var slot: Int = 0
    var type: NamedAPIResource = NamedAPIResource()
}

struct PokemonMove: Codable, Identifiable {
    var id = UUID()
    var move: NamedAPIResource = NamedAPIResource()
    var versionGroupDetails: [PokemonMoveVersion] = []

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct PokemonMoveVersion: Codable {
    var levelLearnedAt: Int = 0
    var moveLearnMethod: NamedAPIResource = NamedAPIResource()
    var versionGroup: NamedAPIResource = NamedAPIResource()

    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}
