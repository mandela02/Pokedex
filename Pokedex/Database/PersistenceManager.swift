//
//  PersistenceManager.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/21/20.
//

import Foundation
import CoreData
import SwiftUI

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
            }
        }
    }
}
