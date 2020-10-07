//
//  AbilitiesResult.swift
//  Pokedex
//
//  Created by TriBQ on 07/10/2020.
//

import Foundation

class AbilitiesResult: Codable {
    var ability: BasePokemonUrlResult = BasePokemonUrlResult(name: "", url: "")
    var isHidden: Bool = false
    var slot: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot = "slot"
    }
}
