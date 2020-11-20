//
//  PokemonEncounterView.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import SwiftUI

struct PokemonEncounterView: View {
    var size: CGSize = CGSize(width: 300, height: 200)

    var body: some View {
        HStack {
            Spacer()
            Image("ic_pokeball")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: size.height/3,
                        y: -size.height/2)
                .foregroundColor(Color.red.opacity(0.5))
        }
    }
}

struct PokemonEncounterView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonEncounterView()
    }
}
