//
//  String+Extension.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
