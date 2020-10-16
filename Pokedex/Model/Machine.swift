//
//  Machine.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation

struct MachineVersionDetail: Codable {
    var machine: APIResource
    var versionGroup: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case machine
        case versionGroup = "version_group"
    }
}

struct Machine: Codable {
    var id: Int = 0
    var item: NamedAPIResource = NamedAPIResource(name: "", url: "")
    var move: NamedAPIResource = NamedAPIResource(name: "", url: "")
    var versionGroup: NamedAPIResource = NamedAPIResource(name: "", url: "")
    
    enum CodingKeys: String, CodingKey {
        case id
        case item
        case move
        case versionGroup = "version_group"
    }
}
