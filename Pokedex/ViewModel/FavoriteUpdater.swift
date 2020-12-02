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
            pokemonUrls = favorites.map({PokedexCellModel(pokemonUrl: $0.pokemonUrl ?? "",
                                                          speciesUrl: $0.speciesUrl ?? "")})
            isEmpty = favorites.isEmpty
        }
    }
    
    @Published var pokemonUrls: [PokedexCellModel] = [] {
        didSet {
            isEmpty = favorites.isEmpty
        }
    }
    
    var didChange =  NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchEntries()
        didChange.sink { [weak self] _ in
            guard let self = self else { return }
            if self.isTopView {
                self.update()
            } else {
                self.refreshing = true
            }
        }.store(in: &cancellables)
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
