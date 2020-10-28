//
//  SearchUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/21/20.
//

import Foundation
import Combine
import CoreData

class SearchDataPrepareUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let context = PersistenceManager.shared.persistentContainer.viewContext
    
    @Published var settings = UserSettings()
    @Published var error: ApiError = .non

    init() {
        oldPokemonsCount = settings.pokemonsCount
        check = true
    }
    
    @Published var oldPokemonsCount: Int = 0
    
    @Published var check: Bool = false {
        didSet {
            loadPokemonResourceToCheck()
        }
    }
    
    @Published var checkedPokemonResult: PokemonResult = PokemonResult() {
        didSet {
            currentlyPokemonCount = checkedPokemonResult.count
        }
    }
    
    @Published var currentlyPokemonCount: Int = 0 {
        didSet {
            if currentlyPokemonCount != oldPokemonsCount {
                delete()
                loadPokemonResource(limit: currentlyPokemonCount)
            } else {
                isDone = true
            }
        }
    }
    
    @Published var currentPokemonsResult: PokemonResult = PokemonResult() {
        didSet {
            settings.pokemonsCount = currentPokemonsResult.count
            for resource in currentPokemonsResult.results {
                let pokemon = NSEntityDescription
                    .insertNewObject(forEntityName: "PokemonsResource", into: context)
                pokemon.setValue(resource.name, forKey: "name")
                pokemon.setValue(resource.url, forKey: "url")
            }
            isDone = true
            save()
        }
    }
    
    @Published var isDone: Bool = false
    
    private func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func delete() {
        let request : NSFetchRequest<PokemonsResource> = PokemonsResource.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let pokemonsResource = try context.fetch(request)
            for resource in pokemonsResource {
                context.delete(resource)
            }
            
        } catch {
            print("Fetch failed: Error \(error.localizedDescription)")
        }
    }
    
    func loadPokemonResourceToCheck() {
        Session
            .share
            .pokemons(from: Constants.baseCheckPokemonUrl)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {  [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished: self.error = .non
                case .failure(let message): self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.checkedPokemonResult = result
            }).store(in: &cancellables)
    }
    
    func loadPokemonResource(limit: Int) {
        Session
            .share
            .pokemons(from: UrlType.getAllPokemonsResource(limit: limit))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: {  [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished: self.error = .non
                case .failure(let message): self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.currentPokemonsResult = result
            }).store(in: &cancellables)
    }
}
