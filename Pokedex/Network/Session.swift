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
    case species

    var urlString: String {
        switch self {
        case .pokemons:
            //return Constants.baseUrl + "pokemon?offset=900&limit=50"
            return Constants.baseUrl + "pokemon?limit=50"
        case .trigger:
            return Constants.baseUrl + "evolution-trigger/"
        case .type:
            return Constants.baseUrl + "type/"
        case .species:
            return Constants.baseUrl + "pokemon-species/?limit=50"
        }
    }
    
    static func getImageUrlString(of order: Int) -> String {
        return String(format: Constants.baseImageUrl, "\(order)")
    }
    
    static func getFrontDefaultImageUrl(of id: Int) -> String {
        return String(format: Constants.baseFrontImageUrl, "\(id)")
    }
    
    static func getPokemonUrl(of order: Int) -> String {
        return Constants.baseUrl + "pokemon/\(order)/"
    }
    
    static func getSpeciesUrl(of order: Int) -> String {
        return Constants.baseUrl + "pokemon-species/\(order)/"
    }

    static func getAbilityUrl(of name: String) -> String {
        return Constants.baseAbilityUrl + name.lowercased()
    }
    
    static func getAllPokemonsResource(limit: Int) -> String {
        return String(format: Constants.allPokemonsUrl, "\(limit)")
    }
}

struct Session {
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
    
    func move(from url: String) -> AnyPublisher<Move, Error> {
        return call(url)
    }
    
    func machine(from url: String) -> AnyPublisher<Machine, Error> {
        return call(url)
    }
    
    func moveLearnMethod(from url: String) -> AnyPublisher<MoveLearnMethod, Error> {
        return call(url)
    }
    
    func moveTarget(from url: String) -> AnyPublisher<MoveTarget, Error> {
        return call(url)
    }
    
    func ability(from url: String) -> AnyPublisher<Ability, Error> {
        return call(url)
    }

    func call<T: Decodable>(_ request: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: request) else {
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .map{ $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}
