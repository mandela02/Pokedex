//
//  UnitHelper.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation

class UnitHelper {
    //In api, weight value is in Hectogram
    static func weightInKg(from hectogram: Int) -> Double {
        return Double(hectogram) * 0.1
    }
    
    static func weightInLbs(from hectogram: Int) -> Double {
        return Double(hectogram) / 4.536
    }
    
    //in api, height value come in decimetres
    static func heightInCm(from decimetre: Int) -> Double {
        return Double(decimetre) * 10
    }
    
    static func heightInInch(from decimetre: Int) -> Double {
        return Double(decimetre) * 3.937
    }
}
