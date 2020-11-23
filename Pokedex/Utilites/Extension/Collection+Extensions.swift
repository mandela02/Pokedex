//
//  Collection+Extensions.swift
//  Pokedex
//
//  Created by SonHoang on 10/29/19.
//  Copyright © 2019 Komorebi. All rights reserved.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }

}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
