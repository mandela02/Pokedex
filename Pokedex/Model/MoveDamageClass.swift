//
//  MoveDamageClass.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/15/20.
//

import Foundation

struct MoveDamageClass: Codable {
    var descriptions: [Description] = []
    var id: Int = 0
    var moves: [NamedAPIResource] = []
    var name: String = ""
}
