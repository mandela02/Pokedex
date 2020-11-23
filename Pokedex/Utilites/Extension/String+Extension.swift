//
//  String+Extension.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/6/20.
//

import SwiftUI

extension String {
    var eliminateDash: String {
        return self.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var image: Image {
        return Image(self)
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
