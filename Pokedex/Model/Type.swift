//
//  type.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation

class Type: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String = ""
    var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

class TypeResult: Codable {
    var slot: Int = 0
    var type: Type = Type()
}
