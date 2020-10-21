//
//  DetailViewWithGif.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
//

import SwiftUI

struct GeneralDetailView: View {
    var pokemon: Pokemon
    var species: Species
    @Binding var selectedString: String?

    @State var showGif = false

    var body: some View {
        GeometryReader(content: { geometry in
            if !pokemon.abilities.isEmpty {
                HStack(alignment: .center, spacing: 10) {
                    VStack(alignment: .leading, spacing: 20) {
                        SpeciesNameView(species: species)
                        AbilitesView(pokemon: pokemon, selectedString: $selectedString)
                            .frame(width: abs(geometry.size.width - 100))
                    }

                    if showGif {
                        GIFView(gifName: pokemon.sprites.versions?.generationV?.blackWhite?.animated?.front ?? "")
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding(.trailing, 10)
                    } else {
                        ZStack {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: pokemon.mainType.color.background))
                                .frame(width: 80, height: 80, alignment: .center)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.linear) {
                            showGif = true
                        }
                    }
                }
            }
        })
    }
}
