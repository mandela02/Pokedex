//
//  SearchUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/21/20.
//

import Foundation
import Combine
import CoreData

class SearchUpdater: ObservableObject {
    private var cancellable: AnyCancellable?

    private let context = PersistenceManager.shared.persistentContainer.viewContext

    @Published var searchValue: String = ""
    @Published var pokemonsResource: [PokemonsResource] = []
    
    init() {
        search()
    }

    private func search() {
        self.cancellable = $searchValue
            .receive(on: RunLoop.main)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] searchString in
                self?.fetchEntries(text: searchString)
            })
    }
    
    private func fetchEntries(text: String) {
        let request: NSFetchRequest<PokemonsResource> = PokemonsResource.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", text.lowercased())
        do {
            let pokemonsResource = try context.fetch(request)
            self.pokemonsResource = pokemonsResource
        } catch {
            print("Fetch failed: Error \(error.localizedDescription)")
        }
    }
}
