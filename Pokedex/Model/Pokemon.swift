//
//  Pokemon.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import SwiftUI

struct Pokemon: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var types: [Type] = []
    var imageUrl: String = ""
    var mainType: PokemonType = .grass
}

struct Type: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
}
