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
    @Published var refreshing = false
    
    @Published var favorites: [Favorite] = [] {
        didSet {
            loadPokemonDetailData()
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
