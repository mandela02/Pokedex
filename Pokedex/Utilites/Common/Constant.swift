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
    static let baseOfficialImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    static let baseImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/%@.png"
    static let basePokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    static let baseMachineUrl = "https://pokeapi.co/api/v2/machine/"
    static let baseAbilityUrl = "https://pokeapi.co/api/v2/ability/"
    static let basePokemonSpeciesUrl = "https://pokeapi.co/api/v2/pokemon-species/"
    static let genderRateMaxChance = 8
    static let allPokemonsUrl = "https://pokeapi.co/api/v2/pokemon/?limit=%@"
    static let baseCheckPokemonUrl = "https://pokeapi.co/api/v2/pokemon/"
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    static let emptyImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/0.png"
    static let baseFrontImageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/%@.png"
    
    static var pokemons: [String] = Array(["abra", "bellsprout", "bullbasaur", "caterpie", "charmander", "dratini", "eevee", "jigglypuff", "mankey", "meowth", "mew", "pidgey", "pikachu", "psyduck", "rattata", "snorlax", "squirtle", "venonat", "weedle", "zubat"].choose(12))
}

struct RegionDex {
    static var kantoAvatar  = [1, 4, 7]
    static var johtoAvatar  = [152, 155, 158]
    static var hoennAvatar  = [252, 255, 258]
    static var sinnohAvatar = [387, 390, 393]
    static var unovaAvatar  = [495, 498, 501]
    static var kalosAvatar  = [650, 635, 656]
    static var alolaAvatar  = [722, 725, 728]
    static var galarAvatar: [Int] = []
}
