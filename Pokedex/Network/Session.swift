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
    case region

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
        case .region:
            return Constants.baseUrl + "region/"
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
    private let cache = ObjectCache<Any>()
    private init() {}
    
    func overallResult(from url: String) -> AnyPublisher<PokemonResult, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let pokemonResult = result.thing as? PokemonResult {
            return Just(pokemonResult)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func pokemon(from url: String) -> AnyPublisher<Pokemon, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let pokemon = result.thing as? Pokemon {
            return Just(pokemon)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func species(from url: String) -> AnyPublisher<Species, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let species = result.thing as? Species {
            return Just(species)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func evolution(from url: String) -> AnyPublisher<Evolution, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let evolution = result.thing as? Evolution {
            return Just(evolution)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }

    func stat(from url: String) -> AnyPublisher<Stat, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let stat = result.thing as? Stat {
            return Just(stat)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func characteristic(from url: String) -> AnyPublisher<Characteristic, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let characteristic = result.thing as? Characteristic {
            return Just(characteristic)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func type(from url: String) -> AnyPublisher<PokeType, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let type = result.thing as? PokeType {
            return Just(type)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func moveDamageClass(from url: String) -> AnyPublisher<MoveDamageClass, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let moveDamageClass = result.thing as? MoveDamageClass {
            return Just(moveDamageClass)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func move(from url: String) -> AnyPublisher<Move, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let move = result.thing as? Move {
            return Just(move)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func machine(from url: String) -> AnyPublisher<Machine, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let machine = result.thing as? Machine {
            return Just(machine)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func moveLearnMethod(from url: String) -> AnyPublisher<MoveLearnMethod, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let moveLearnMethod = result.thing as? MoveLearnMethod {
            return Just(moveLearnMethod)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func moveTarget(from url: String) -> AnyPublisher<MoveTarget, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let moveTarget = result.thing as? MoveTarget {
            return Just(moveTarget)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func ability(from url: String) -> AnyPublisher<Ability, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let ability = result.thing as? Ability {
            return Just(ability)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func region(from url: String) -> AnyPublisher<Region, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let region = result.thing as? Region {
            return Just(region)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }

    func pokedex(from url: String) -> AnyPublisher<Pokedex, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let pokedex = result.thing as? Pokedex {
            return Just(pokedex)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }

    func location(from url: String) -> AnyPublisher<Location, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let location = result.thing as? Location {
            return Just(location)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }

    func area(from url: String) -> AnyPublisher<LocationArea, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let area = result.thing as? LocationArea {
            return Just(area)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func encounterMethod(from url: String) -> AnyPublisher<EncounterMethod, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let encounterMethod = result.thing as? EncounterMethod {
            return Just(encounterMethod)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
        return call(url)
    }
    
    func condition(from url: String) -> AnyPublisher<Condition, Error> {
        if let result = cache.get(for: url) as? CacheHolder<Any>, let condition = result.thing as? Condition {
            return Just(condition)
                .tryMap { $0 }
                .eraseToAnyPublisher()
        }
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
            .handleEvents(receiveOutput: { out in
                cache.set(for: request, object: CacheHolder(thing: out))
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
}

class CacheHolder<T>: NSObject {
    let thing: T
    init(thing: T) {
        self.thing = thing
    }
}

class ObjectCache<T> {
    private let cache = NSCache<NSString, CacheHolder<T>>()
    
    func get(for key: String) -> T? {
        return cache.object(forKey: NSString(string: key)) as? T
    }
    
    func set(for key: String, object: CacheHolder<T>) {
        cache.setObject(object, forKey: NSString(string: key))
    }
}
