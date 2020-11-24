//
//  CoreData.swift
//  Pokedex
//
//  Created by TriBQ on 21/11/2020.
//

import Foundation
import CoreData

struct CoreData {
    static private let viewContext = PersistenceManager.shared.persistentContainer.viewContext
    
    static func like(pokemon: String) {
        let favorite = Favorite(context: viewContext)
        favorite.url = pokemon
        save()
    }
    
    static func dislike(pokemon: String) {
        let favorites = fetchEntries()
        guard let item = favorites.first(where: {$0.url == pokemon}) else {
            return
        }
        viewContext.delete(item)
        save()
    }
    
    static private func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static private func fetchEntries() -> [Favorite] {
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favorites = try viewContext.fetch(request)
            return favorites
        } catch {
            return []
        }
    }
    
    static func isFavorite(pokemon: String) -> Bool {
        let favorites = fetchEntries()
        return favorites.map({$0.url}).contains(pokemon)
    }
}
