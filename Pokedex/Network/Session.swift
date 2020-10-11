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
    case images

    var urlString: String {
        switch self {
        case .pokemons:
            //"pokemon?offset=900&limit=50"
            return Constants.baseUrl + "pokemon?limit=50"
        case .images:
            return Constants.baseImageUrl
        }
    }
    
    static func getImageUrlString(of pokemon: Pokemon) -> String {
        return String(format: Constants.baseImageUrl, "\(pokemon.order)")
    }
}

class Session {
    static let share = Session()

    private init() {}
    
    func pokemons(from url: String) -> AnyPublisher<PokemonResult, Error>? {
        return call(url)
    }
    
    func pokemon(from url: String) -> AnyPublisher<Pokemon, Error>? {
        return call(url)
    }
    
    func species(from url: String) -> AnyPublisher<Species, Error>? {
        return call(url)
    }
    
    func evolution(from url: String) -> AnyPublisher<Evolution, Error> {
        return call(url)
    }

    func stat(from url: String) -> AnyPublisher<Stat, Error> {
        return call(url)
    }
    
    func characteristic(from url: String) -> AnyPublisher<Characteristic, Error> {
        return call(url)
    }
    
    func call<T: Decodable>(_ request: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: request) else {
            return PassthroughSubject<T, Error>().eraseToAnyPublisher()
        }
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}
