//
//  UIApplication+Extension.swift
//  Pokedex
//
//  Created by TriBQ on 22/11/2020.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
