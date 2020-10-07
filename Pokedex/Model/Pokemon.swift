//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import SwiftUI

class Pokemon: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var types: [TypeResult] = []
    var sprites: PokemonImage = PokemonImage()
    var order: Int = 0
    var species: BasePokemonUrlResult = BasePokemonUrlResult(name: "", url: "")
    var baseExp: Int = 0
    var height: Int = 0
    var weight: Int = 0
    var abilities: [AbilitiesResult] = []
    
    var mainType: PokemonType {
        return PokemonType.type(from: types.first?.type.name)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case types = "types"
        case sprites = "sprites"
        case order = "order"
        case species = "species"
        case baseExp = "base_experience"
        case height = "height"
        case weight = "weight"
        case abilities = "abilities"
    }
}

class PokemonImage: Codable {
    var back: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var front: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
    var other: OtherImageResult = OtherImageResult()

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
    }
}

class OtherImage: Codable {
    var front: String = ""
    var frontFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case front = "front_default"
        case frontFemale = "front_female"
    }
}

class OtherImageResult: Codable {
    var dreamWorld: OtherImage = OtherImage()
    var artwork: OtherImage = OtherImage()
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case artwork = "official-artwork"
    }
}
