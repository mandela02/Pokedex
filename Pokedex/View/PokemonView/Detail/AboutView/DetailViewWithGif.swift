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

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    PokemonNameView(pokemon: pokemon)
                    SpeciesNameView(species: species)
                    DescriptionView(species: species)
                }.padding(.leading, 10)
                Spacer()
                GifWithProgressView(url: pokemon.sprites.versions?.generationV?.blackWhite?.animated?.front ?? "",
                                    color: pokemon.mainType.color.background)
            }.frame(height: 120, alignment: .center)
            if !(pokemon.abilities?.isEmpty ?? true) {
                AbilitesView(pokemon: pokemon)
            }
        }.padding(.bottom, 10)
    }
}

struct GifWithProgressView: View {
    var url: String
    var color: Color
    @State var showGif = false
    
    var body: some View {
        Group {
            if showGif {
                GIFView(gifName: url)
            } else {
                ZStack {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: color))
                }
            }
        }
        .frame(width: 80, height: 80, alignment: .center)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.linear) {
                    showGif = true
                }
            }
        }
    }
}
