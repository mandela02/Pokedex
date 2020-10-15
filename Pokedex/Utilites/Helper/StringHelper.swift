//
//  StringHelper.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/9/20.
//

import Foundation
import SwiftUI

class StringHelper {
    static func getEnglishTexts(from texts: [FlavorTextEntry]) -> String {
        let englishText = texts.filter({$0.language.name == "en"}).map({$0.flavorText}).uniques.prefix(5)
        return englishText
            .map({$0.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)})
            .joined(separator: "\n")
    }
    
    static func getRandomEnglishText(from texts: [FlavorTextEntry]) -> String {
        let englishText = texts.filter({$0.language.name == "en"}).map({$0.flavorText}).uniques
        return englishText
            .map({$0.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)})
            .randomElement() ?? ""
    }
    
    static func getEnglishText(from texts: [Description]) -> String {
        return texts.filter({$0.language.name == "en"}).map({$0.description}).uniques.first ?? ""
    }
    
    static func getEnglishText(from texts: [EffectEntry]) -> String {
        return texts.filter({$0.language.name == "en"}).map({$0.effect}).uniques.first ?? ""
    }
    
    static func weightString(from hectogram: Int) -> String {
        let weight = "%@kg (%@lbs)"
        let kilogramString = String(format: "%.1f", UnitHelper.weightInKg(from: hectogram))
        let poundsString = String(format: "%.1f", UnitHelper.weightInLbs(from: hectogram))
        return String(format: weight, kilogramString, poundsString)
    }
    
    static func heightString(from decimetre: Int) -> String {
        let cmString = String(format: "%.1f", UnitHelper.heightInInch(from: decimetre))
        let inchString = decimeterToFeetInches(decimetre)

        return String(format: "%@cm (%@)", cmString, inchString)
    }
    
    static func decimeterToFeetInches(_ decimeter: Int) -> String {
        let value = Double(decimeter) * 3.048
      let formatter = MeasurementFormatter()
      formatter.unitOptions = .providedUnit
      formatter.unitStyle = .short

      let rounded = value.rounded(.towardZero)
      let feet = Measurement(value: rounded, unit: UnitLength.feet)
      let inches = Measurement(value: value - rounded, unit: UnitLength.feet).converted(to: .inches)
      return ("\(formatter.string(from: feet)) \(formatter.string(from: inches))")
    }

    static func getGenderRateString(gender: Gender, rate: Int) -> String {
        if gender == .non {
            return "100%"
        }
        let femaleRate: Double = Double(rate) / Double(Constants.genderRateMaxChance) * 100
        let maleRate = 100 - femaleRate
        
        return String(format: "%.1f%", gender == .female ? femaleRate : maleRate)
    }
    
    static func getPokemonId(from url: String) -> Int {
        var base = Constants.basePokemonUrl
        if url.contains("pokemon-species") {
            base = Constants.basePokemonSpeciesUrl
        }
        return Int(url.replacingOccurrences(of: base, with: "")
                    .replacingOccurrences(of: "/", with: "")) ?? 0
    }
    
    static func getStringLength(text: String) -> CGSize {
        let font = UIFont(name: "Biotif-Book", size: 10)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let nsText = text as NSString
        return nsText.size(withAttributes: fontAttributes)
    }
}
