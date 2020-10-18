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
    @State private var refreshing = false
    @Published var favorites: [Favorite] = []
    @Published var cells: [PokemonCellModel] = []
        
    init() {
        fetchEntries()
    }
    
    func prepare(from favorites: [Favorite]) {
        let resource = favorites.map({NamedAPIResource(name: "", url: $0.url ?? "")})
        cells = PokemonCellModel.getCells(from: resource)
    }
    
    func fetchEntries() {
        let context = PersistenceManager.shared.persistentContainer.viewContext
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favorites = try context.fetch(request)
            prepare(from: favorites)
        } catch {
            print("Fetch failed: Error \(error.localizedDescription)")
            cells = []
        }
    }
}
