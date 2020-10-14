//
//  CustomText.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/14/20.
//

import Foundation
import SwiftUI

struct CustomText: View {
    var text: String = ""
    var size: CGFloat = 0.0
    var weight: Font.Weight = .bold
    var background: Color = .clear
    var textColor: Color = .black
    
    var body: some View {
        Text(text)
            .font(.custom("PKMN-RBYGSC", size: size))
            .fontWeight(weight)
            .foregroundColor(textColor)
            .background(background)
    }
}
