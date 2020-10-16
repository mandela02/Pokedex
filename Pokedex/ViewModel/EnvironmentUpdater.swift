//
//  environment.swift
//  Pokedex
//
//  Created by TriBQ on 16/10/2020.
//

import Foundation
import SwiftUI
import Combine

class EnvironmentUpdater: ObservableObject {
    @Published var selectedPokemon: String = ""
    @Published var selectedType: PokemonType = .non
}
