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
    case trigger
    case type

    var urlString: String {
        switch self {
        case .pokemons:
            //return Constants.baseUrl + "pokemon?offset=900&limit=50"
            return Constants.baseUrl + "pokemon?limit=200"
        case .trigger:
            return Constants.baseUrl + "evolution-trigger/"
        case .type:
            return Constants.baseUrl + "type/"
        }
    }
    
    static func getImageUrlString(of order: Int) -> String {
        return String(format: Constants.baseImageUrl, "\(order)")
    }
    
    static func getPokemonUrl(of order: Int) -> String {
        return Constants.baseUrl + "pokemon/\(order)/"
    }
}

class Session {
    static let share = Session()

    private init() {}
    
    func pokemons(from url: String) -> AnyPublisher<PokemonResult, Error> {
        return call(url)
    }
    
    func pokemon(from url: String) -> AnyPublisher<Pokemon, Error> {
        return call(url)
    }
    
    func species(from url: String) -> AnyPublisher<Species, Error> {
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
    
    func allTriggers(from url: String) -> AnyPublisher<EvolutionTriggers, Error> {
        return call(url)
    }

    func type(from url: String) -> AnyPublisher<PokeType, Error> {
        return call(url)
    }
    
    
    func moveDamageClass(from url: String) -> AnyPublisher<MoveDamageClass, Error> {
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
