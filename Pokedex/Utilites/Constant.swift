//
//  Constant.swift
//  Pokedex
//
//  Created by TriBQ on 05/10/2020.
//

import Foundation
import SwiftUI

struct Constants {
    static let baseUrl = "https://pokeapi.co/api/v2/"
    static let baseImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/%@.png"
    static let basePokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    static let baseMachineUrl = "https://pokeapi.co/api/v2/machine/"
    static let baseAbilityUrl = "https://pokeapi.co/api/v2/ability/"
    static let basePokemonSpeciesUrl = "https://pokeapi.co/api/v2/pokemon-species/"
    static let genderRateMaxChance = 8
    static let allPokemonsUrl = "https://pokeapi.co/api/v2/pokemon/?limit=%@"
    static let baseCheckPokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
}
