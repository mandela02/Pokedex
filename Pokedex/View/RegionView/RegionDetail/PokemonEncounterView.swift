//
//  PokemonEncounterView.swift
//  Pokedex
//
//  Created by TriBQ on 20/11/2020.
//

import SwiftUI

struct PokemonEncounterView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let width = geometry.size.width - 60
            let height = width * 0.4
            Color.red.ignoresSafeArea()
            //background ball
            HStack {
                Spacer()
                Image("ic_pokeball")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white.opacity(0.5))
                    .offset(x: geometry.size.width / 3, y: -geometry.size.height/5)
            }
            // pokemon image
            HStack {
                Spacer()
                Image("pokeball")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: geometry.size.width/6)
            }

            VStack(alignment: .leading, spacing: 10) {
                PokemonLocationNameAndNumberView()
                PokemonPositionView()
                ScrollView(content: {
                    LazyVStack {
                        ForEach((0...10), id: \.self) { index in
                            EncounterListCellView(size: CGSize(width: width, height: height))
                        }
                    }
                })
            }
        })
    }
}

struct PokemonLocationNameAndNumberView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Charmander")
                    .font(Biotif.extraBold(size: 35).font)
                    .foregroundColor(.white)
                    .frame(alignment: .topLeading)
                    .lineLimit(1)
                
                Spacer()
                
                Text("#005")
                    .font(Biotif.extraBold(size: 20).font)
                    .foregroundColor(Color(.systemGray3))
                    .frame(alignment: .topLeading)
                    .lineLimit(1)
                    .shadow(color: .black, radius: 2)
            }
            
            ForEach(["Fire"]) { type in
                TypeBubbleCellView(text: type,
                                   foregroundColor: Color.white,
                                   backgroundColor: Color.white.opacity(0.3),
                                   font: Biotif.semiBold(size: 20).font)
                    .padding(.leading, 15)
            }
            
        }
        .padding()
    }
}

struct PokemonLocationView: View {
    var body: some View {
        HStack {
            Text("Location")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .frame(width: 100, alignment: .leading)
            Text("Celadon City")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
        }.shadow(color: .black, radius: 1)
    }
}

struct PokemonAreaView: View {
    var body: some View {
        HStack {
            Text("Area")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .frame(width: 100, alignment: .leading)
            Text("Celadon City Area")
                .font(Biotif.medium(size: 15).font)
                .foregroundColor(.white)
                .frame(alignment: .leading)
        }.shadow(color: .black, radius: 1)
    }
}

struct PokemonPositionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            PokemonLocationView()
            PokemonAreaView()
        }.padding()
    }
}

struct EncounterListCellView: View {
    var size: CGSize

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EncounterChangeView()
            MinMaxLevelView()
            EncounterView()
        }
        .shadow(color: .black, radius: 1)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5),
                        lineWidth: 5)
        )
        .background(Color.red.opacity(0.7))
        .cornerRadius(20)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct EncounterChangeView: View {
    var fontSize: CGFloat = 12

    var body: some View {
        HStack {
            Text("Encounter chance: ")
                .foregroundColor(.white)
                .font(Biotif.medium(size: fontSize).font)
            Text("20%")
                .foregroundColor(.white)
                .font(Biotif.bold(size: fontSize).font)
        }.shadow(color: .red, radius: 1)
    }
}

struct MinMaxLevelView: View {
    var fontSize: CGFloat = 12

    var body: some View {
        HStack(spacing: 5) {
            HStack {
                Text("Min Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("5")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: .red, radius: 1)
            
            HStack {
                Text("Max Level: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: fontSize).font)
                Text("20")
                    .foregroundColor(.white)
                    .font(Biotif.bold(size: fontSize).font)
                Spacer()
            }.shadow(color: .red, radius: 1)
        }.padding(.top, 10)
    }
}

struct EncounterView: View {
    var fontSize: CGFloat = 12
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Method: ")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
                Text("Surf")
                    .foregroundColor(.white)
                    .font(Biotif.medium(size: 15).font)
            }
            .shadow(color: .red, radius: 1)
            
            Text("Use surf to catch this pokemon")
                .foregroundColor(Color.white.opacity(0.8))
                .font(Biotif.medium(size: fontSize).font)
                .padding(.leading, 10)
                .shadow(color: .red, radius: 1)
        }
        .padding(.top, 10)
    }
}

struct PokemonEncounterView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonEncounterView()
    }
}
