//
//  PokemonEncounterView.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import SwiftUI

struct PokemonEncounterView: View {
    @StateObject var updater = PokemonEncounterUpdater()
    
    var encounter: AreaPokedexCellModel
    
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 60
            let height = width * 0.4
            updater.pokemonEncounterModel.pokemon.mainType.color.background.ignoresSafeArea()
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white.opacity(0.5))
                    .offset(x: geometry.size.width / 3, y: -geometry.size.height/5)
            }
            HStack {
                Spacer()
                DownloadedImageView(withURL: updater.pokemonEncounterModel.pokemon.sprites.other?.artwork.front ?? "",
                                    style: .animated)
                    .offset(x: geometry.size.width/6)
                    .padding()
            }

            VStack(alignment: .leading, spacing: 10) {
                PokemonLocationNameAndNumberView(pokemon: updater.pokemonEncounterModel.pokemon)
                PokemonPositionView(location: updater.pokemonEncounterModel.location,
                                    area: updater.pokemonEncounterModel.area)
                ScrollView(content: {
                    LazyVStack {
                        ForEach(updater.pokemonEncounterModel.encounter) { model in
                            EncounterListCellView(size: CGSize(width: width, height: height),
                                                  model: model)
                        }
                    }
                })
            }
        }).onAppear(perform: {
            updater.pokemonEncounter = encounter
        }).transition(.opacity)
        .animation(.default)
    }
}

struct PokemonLocationNameAndNumberView: View {
    var pokemon: Pokemon
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(pokemon.name.capitalizingFirstLetter())
                    .font(Biotif.extraBold(size: 35).font)
                    .foregroundColor(.white)
                    .frame(alignment: .topLeading)
                    .lineLimit(1)
                
                Spacer()
                
                Text(String(format: "#%03d", pokemon.pokeId))
                    .font(Biotif.extraBold(size: 20).font)
                    .foregroundColor(Color(.systemGray3))
                    .frame(alignment: .topLeading)
                    .lineLimit(1)
                    .shadow(color: .black, radius: 2)
            }
            HStack(alignment: .center, spacing: 30, content: {
                ForEach(pokemon.types.map({$0.type})) { type in
                    TappableNewTypeView(type: type)
                }
            })
        }
        .padding()
    }
}

struct PokemonLocationView: View {
    var location: String

    var body: some View {
        HStack {
            Text("Location")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .frame(width: 100, alignment: .leading)
            Text(location)
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
        }.shadow(color: .black, radius: 1)
    }
}

struct PokemonAreaView: View {
    var area: String

    var body: some View {
        HStack {
            Text("Area")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .frame(width: 100, alignment: .leading)
            Text(area)
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
        }.shadow(color: .black, radius: 1)
    }
}

struct PokemonPositionView: View {
    var location: String
    var area: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            PokemonLocationView(location: location)
            PokemonAreaView(area: area)
        }.padding()
    }
}

struct EncounterListCellView: View {
    var size: CGSize
    var model: EncounterChanceCellModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EncounterChangeView(model: model)
            MinMaxLevelView(model: model)
            HowToCatchView(model: model)
        }
        .shadow(color: .black, radius: 1)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5),
                        lineWidth: 5)
        )
        .background(model.color.opacity(0.7))
        .cornerRadius(20)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct EncounterChangeView: View {
    var fontSize: CGFloat = 12
    var model: EncounterChanceCellModel

    var body: some View {
        HStack {
            Text("Encounter chance: ")
                .foregroundColor(.white)
                .font(Biotif.medium(size: fontSize).font)
            Text(" \(model.chance)%")
                .foregroundColor(.white)
                .font(Biotif.bold(size: fontSize).font)
        }.shadow(color: model.color, radius: 1)
    }
}

struct MinMaxLevelView: View {
    var fontSize: CGFloat = 12
    var model: EncounterChanceCellModel

    var body: some View {
        HStack(spacing: 5) {
            HStack {
                Text("Min Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("\(model.min)")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: model.color, radius: 1)
            
            HStack {
                Text("Max Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("\(model.max)")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: model.color, radius: 1)
        }.padding(.top, 10)
    }
}

struct EncounterView: View {
    var fontSize: CGFloat = 12
    var model: EncounterChanceCellModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Method: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
                Text(model.name)
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
            }
            .shadow(color: model.color, radius: 1)
            
            Text(model.description)
                .foregroundColor(Color.white.opacity(0.8))
                .font(Biotif.medium(size: fontSize).font)
                .padding(.leading, 10)
                .shadow(color: model.color, radius: 1)
        }
        .padding(.top, 10)
    }
}

struct ConditionView: View {
    var model: EncounterChanceCellModel

    var body: some View {
        FlexibleGridView(characteristics: .constant(model.conditions),
                         background: Color.white.opacity(0.5))
    }
}

struct HowToCatchView: View {
    var model: EncounterChanceCellModel
    
    var body: some View {
        HStack {
            EncounterView(model: model)
            ConditionView(model: model)
        }
    }
}



