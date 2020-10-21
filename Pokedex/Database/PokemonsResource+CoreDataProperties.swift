//
//  PokemonsResource+CoreDataProperties.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/21/20.
//
//

import Foundation
import CoreData


extension PokemonsResource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonsResource> {
        return NSFetchRequest<PokemonsResource>(entityName: "PokemonsResource")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension PokemonsResource : Identifiable {

}
