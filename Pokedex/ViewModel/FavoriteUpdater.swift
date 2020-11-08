//
//  FavoriteUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class FavoriteUpdater: ObservableObject {
    @Published var isTopView: Bool = true {
        didSet {
            if refreshing && isTopView{
                update()
                refreshing = false
            }
        }
    }

    @Published var refreshing = false
    @Published var isEmpty: Bool = false
    @Published var favorites: [Favorite] = [] {
        didSet {
            //loadPokemonDetailData()
            pokemonUrls = favorites.map({$0.url ?? ""})
            isEmpty = favorites.isEmpty
        }
    }
    
    @Published var pokemonUrls: [String] = [] {
        didSet {
            isEmpty = favorites.isEmpty
        }
    }
    
    @Published var pokemons: [Pokemon] = []
    var didChange =  NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchEntries()
    }
        
    private func loadPokemonDetailData() {
        if favorites.isEmpty {
            pokemons = []
            return
        }
        Publishers.MergeMany(favorites.map({Session.share.pokemon(from: $0.url ?? "")}))
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemons, on: self)
            .store(in: &cancellables)
    }

    private func fetchEntries() {
        let context = PersistenceManager.shared.persistentContainer.viewContext
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favorites = try context.fetch(request)
            self.favorites = favorites
        } catch {
            print("Fetch failed: Error \(error.localizedDescription)")
        }
    }
    
    func update() {
        fetchEntries()
    }
}
