//
//  Region.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import Foundation

enum RegionAvatars: String, CaseIterable {
    case kanto
    case johto
    case hoenn
    case sinnoh
    case unova
    case kalos
    case alola
    case galar
    case non
    
    var avatar: [Int] {
        switch self {
        case .kanto:
            return RegionDex.kantoAvatar
        case .johto:
            return RegionDex.johtoAvatar
        case .hoenn:
            return RegionDex.hoennAvatar
        case .sinnoh:
            return RegionDex.sinnohAvatar
        case .unova:
            return RegionDex.unovaAvatar
        case .kalos:
            return RegionDex.kalosAvatar
        case .alola:
            return RegionDex.alolaAvatar
        case .galar:
            return RegionDex.galarAvatar
        case .non:
            return []
        }
    }
    
    static func region(from name: String) -> RegionAvatars {
        return self.allCases.first(where: {$0.rawValue.contains(name)}) ?? .non
    }
}

struct Region: Codable {
    var id: Int = 0
    var locations: [NamedAPIResource] = []
    var pokedexes: [NamedAPIResource] = []
    var names: [Name] = []
}
