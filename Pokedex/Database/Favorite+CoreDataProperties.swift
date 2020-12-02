//
//  Favorite+CoreDataProperties.swift
//  Pokedex
//
//  Created by TriBQ on 18/10/2020.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var pokemonUrl: String?
    @NSManaged public var speciesUrl: String?

}

extension Favorite : Identifiable {

}
