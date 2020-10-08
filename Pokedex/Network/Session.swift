//
//  Session.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation
import Combine

enum UrlType: String, CaseIterable {
    case pokemons

    var urlString: String {
        switch self {
        case .pokemons:
            return Constants.baseUrl + "pokemon?limit=50"
        }
    }
}

class Session {
    static let share = Session()

    private init() {}
    
    func pokemons(from url: String) -> AnyPublisher<PokemonResult, Error>? {
        guard let url = URL(string: url) else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: PokemonResult.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func pokemon(from url: String) -> AnyPublisher<Pokemon, Error>? {
        guard let url = URL(string: url) else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
