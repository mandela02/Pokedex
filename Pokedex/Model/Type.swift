//
//  type.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation

class TypeResult: Codable {
    var slot: Int = 0
    var type: NamedAPIResource = NamedAPIResource(name: "", url: "")
}
